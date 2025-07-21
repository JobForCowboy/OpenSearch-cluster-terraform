# Outputs

output "boot_disk_ids" {
  value = { for disk in yandex_compute_disk.boot_disk : disk.name => disk.id }
}

output "instance_ids" {
  value = { for instance in yandex_compute_instance.this : instance.name => instance.id }
}

output "instance_public_ip_addresses" {
  value = {
    for instance in yandex_compute_instance.this :
    instance.name => try(instance.network_interface[0].nat_ip_address, "No public IP")
  }
}

output "subnet_ids" {
  value = {
    for subnet in module.net.public_subnets :
    subnet.zone => subnet.subnet_id
  }
}

output "serial_port_files" {
  description = "The Serial port's output files."
  value = [
    for instance in yandex_compute_instance.this :
    "serial_output_${instance.name}.txt"
  ]
}