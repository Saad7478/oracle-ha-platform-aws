Host bastion
    HostName ${bastion_ip}
    User ec2-user
    IdentityFile ~/.ssh/aws-oracle-lab
    ForwardAgent yes
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host primary
    HostName ${primary_ip}
    User ec2-user
    IdentityFile ~/.ssh/aws-oracle-lab
    ProxyJump bastion
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host standby
    HostName ${standby_ip}
    User ec2-user
    IdentityFile ~/.ssh/aws-oracle-lab
    ProxyJump bastion
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null