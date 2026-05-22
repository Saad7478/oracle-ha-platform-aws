[bastion]
bastion_ec2 ansible_host=${bastion_ip} ec2_instance_id=${bastion_id}

[primary]
primary_db ansible_host=${primary_ip} ec2_instance_id=${primary_id}

[standby]
standby_db ansible_host=${standby_ip} ec2_instance_id=${standby_id}

[oracle_servers:children]
primary
standby

[oracle_servers:vars]
ansible_ssh_common_args='-o ProxyJump=rocky@${bastion_ip} -o ForwardAgent=yes'