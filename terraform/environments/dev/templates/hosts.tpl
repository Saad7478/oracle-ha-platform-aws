[bastion]
bastion ansible_host=${bastion_ip}

[primary]
primary_db ansible_host=${primary_ip}

[standby]
standby_db ansible_host=${standby_ip}

[oracle_servers:children]
primary
standby

[oracle_servers:vars]
ansible_ssh_common_args='-o ProxyJump=ec2-user@${bastion_ip} -o ForwardAgent=yes'