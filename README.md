Markdown
# Oracle HA Platform on AWS

Oracle HA Platform on AWS is a project demonstrating the automated deployment of an Oracle High Availability platform on AWS using Oracle Data Guard.

## Description

The project leverages:
* **Terraform** for Infrastructure as Code (IaC).
* **Ansible** for automation and configuration management.
* **Oracle Database with Oracle Data Guard** for high availability.

The objective is to build a modern cloud-based Oracle platform featuring:
* Bastion architecture and private subnets.
* Full Oracle lifecycle automation.
* Platform DBA / Cloud DBA engineering practices.

### Key Features Demonstrated
* AWS infrastructure automation with Terraform.
* Oracle Database 19c deployment automation with Ansible.
* Bastion-based private subnet architecture.
* Oracle Data Guard High Availability & Oracle Data Guard Broker.
* Infrastructure-as-Code and DBA automation practices.

The goal of the project is to simulate a production-style Oracle HA environment while developing Cloud DBA / Platform DBA skills.

---

## Architecture

![Architecture](docs/architecture.png)

---

## Getting Started

### Dependencies

Before deploying the platform, ensure the following prerequisites are available:

* **An AWS Account:** You can use an AWS Free Tier account for testing and lab purposes.
* **A DynamoDB Table:** Used for Terraform state locking and centralized state management.
* **An Amazon S3 Bucket:** Used to store the `terraform.tfstate` file and host the Oracle installation binaries required for deployment.
* **Local Tools Installation:** The following tools must be installed on your workstation:
    * Terraform
    * Ansible
    * AWS Command Line Interface (CLI)
    * Visual Studio Code (or any preferred IDE)
* **An AWS SSH Key Pair:** Required to access the bastion host and private instances through Ansible and SSH ProxyJump.

### Installing & Executing Program

#### 1. Clone the Repository
```bash
git clone https://github.com/Saad7478/oracle-ha-platform-aws.git
cd oracle-ha-platform-aws
```

#### 2. Configure AWS CLI
Configure your AWS credentials locally:

```Bash
aws configure
```
Provide your AWS Access Key, Secret Key, Default region, and Output format.

#### 3. Configure Terraform Backend & Variables
Update the backend configuration in oracle-ha-platform-aws/terraform/environments/dev/main.tf:
```hcl
Terraform
terraform {
  backend "s3" {
    bucket         = "my-terraform-statexxx"
    key            = "oracleDG/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    profile        = "aws2"
  }
}
```
Update your variables in oracle-ha-platform-aws/terraform/environments/dev/terraform.tfvars:

```hcl
Terraform
cidr = "10.0.0.0/16"

public_azs  = ["us-east-2a", "us-east-2b"]
primary_azs = ["us-east-2a"]
standby_azs = ["us-east-2b"]

public_subnets  = ["10.0.1.0/24"]
private_primary = ["10.0.10.0/24"]
private_standby = ["10.0.20.0/24"]
```

#### 4. Upload Oracle 19c Binaries to S3
Upload the Oracle installation ZIP files to your S3 bucket:

```Bash
aws s3 cp LINUX.X64_193000_db_home.zip s3://your-oracle-binaries-bucket/
```

#### 5. Initialize Terraform

```Bash
cd terraform/environments/dev
terraform init
```

#### 6. Review Infrastructure Plan

```Bash
terraform plan
```

#### 7. Deploy AWS Infrastructure

```Bash
terraform apply
```

This deployment creates the following resources:

* VPC, Public/Private subnets, Internet Gateway, NAT Gateway, Route tables, and Elastic IPs.
* Security groups & IAM Roles.
* EC2 Bastion host, EC2 Primary Oracle server, and EC2 Standby Oracle server.

#### 8. Generate Ansible Inventory
Terraform automatically generates the Ansible inventory file using Terraform outputs.

Example of a generated inventory:

```Ini, TOML
[bastion]
bastion_ec2 ansible_host=3.151.185.42 ec2_instance_id=i-0b9561c507c893b90

[primary]
primary_db ansible_host=10.0.10.113 ec2_instance_id=i-08b444b7fa62brc40

[standby]
standby_db ansible_host=10.0.20.137 ec2_instance_id=i-01bdcc4c64cd61a35

[oracle_servers:children]
primary
standby

[oracle_servers:vars]
ansible_ssh_common_args='-o ProxyJump=rocky@3.151.185.42 -o ForwardAgent=yes'
```

#### 9. Configure SSH Access
Example of generated SSH configuration file (~/.ssh/config):

```text
Host bastion
    HostName 3.151.185.42
    User rocky
    IdentityFile ~/.ssh/aws-oracle-lab
    ForwardAgent yes
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host primary
    HostName 10.0.10.113
    User rocky
    IdentityFile ~/.ssh/aws-oracle-lab
    ProxyJump bastion
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host standby
    HostName 10.0.20.137
    User rocky
    IdentityFile ~/.ssh/aws-oracle-lab
    ProxyJump bastion
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

#### 10. Test Connectivity

```Bash
ssh primary
ssh standby
```

#### 11. Create Ansible Vault
Create an encrypted file for your database secrets:

```Bash
ansible-vault create playbooks/group_vars/vault.yaml
```
Define your passwords inside the vault:

```YAML
vault_sys_password: "Oracle#123"
vault_system_password: "Oracle#123"
vault_pdbadmin_password: "Oracle#123"
```
To automate execution, save your vault password in a protected file:

```Bash
echo "oracle" > .vault_pass
chmod 600 .vault_pass
```

#### 12. Start SSH Agent and Add Key
Ensure your SSH agent is running and contains your AWS private key:

```Bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/aws-oracle-lab
```

#### 13. Run Ansible Playbooks
Execute the master playbook to configure the entire platform:

```Bash
ansible-playbook playbooks/site.yaml --vault-password-file .vault_pass
```
This command triggers the following automation sequence:

* Oracle prerequisites: oracle_prereqs.yml
* Oracle software installation: oracle_install.yml
* Database creation: oracle_db_creation.yaml
* Enable ARCHIVELOG: oracle_archivelog.yaml
* Configure Data Guard: oracle_dataguard_prepare.yaml
* Create standby database: oracle_dataguard_standby.yml
* Validate Data Guard: oracle_dataguard_verify.yaml
* Configure Data Guard Broker: oracle_dataguard_broker.yml

#### 14. Validate Oracle Data Guard
Connect to the primary database via SQL*Plus:

```SQL
sqlplus / as sysdba
```
Run validation queries:

```SQL
SELECT database_role FROM v$database;
SELECT process, status FROM v$managed_standby;
```
Verify the setup via Data Guard Broker Command Line (dgmgrl):

```Bash
dgmgrl sys/password
```
```text
show configuration;
```
Expected output status: SUCCESS

## Troubleshooting & Tips
* SSH ProxyJump Issues: Ensure ssh-agent is correctly running and that your local identity file matches the one defined in ~/.ssh/config.

* S3 Binary Downloads: If Ansible fails during the installation step, verify that the EC2 instances have the correct IAM instance profile permissions to pull files from your specific S3 bucket.

## Authors
Saad BRAHMIA - @Saad7478 - [LinkedIn Profile](https://www.linkedin.com/in/saad-brahmia-48109430/)

Version History
0.1

Initial Release (Automated Terraform infrastructure & Ansible playbooks for Data Guard setup).

## License
This project is licensed under the MIT License - feel free to copy, modify, and use it as you wish. 