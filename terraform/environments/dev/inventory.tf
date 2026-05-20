resource "local_file" "ansible_inventory" {
  filename = "../../../ansible/inventories/dev/hosts.ini"

  content = templatefile("${path.module}/templates/hosts.tpl", {
    bastion_ip = module.compute.bastion_eip
    primary_ip = module.compute.primary_private_ip
    standby_ip = module.compute.standby_private_ip

    bastion_id = module.compute.bastion_instance_id
    primary_id = module.compute.primary_instance_id
    standby_id = module.compute.standby_instance_id
  })
}

resource "local_file" "ssh_config" {
  filename = pathexpand("~/.ssh/oracle-lab-config")

  file_permission = "0600"

  content = templatefile("${path.module}/templates/ssh_config.tpl", {
    bastion_ip = module.compute.bastion_eip
    primary_ip = module.compute.primary_private_ip
    standby_ip = module.compute.standby_private_ip
  })
}