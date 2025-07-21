# Local values
locals {
  boot_disk_name   = var.boot_disk_name != null ? var.boot_disk_name : "${var.name_prefix}-boot-disk"
  linux_vm_name    = var.linux_vm_name != null ? var.linux_vm_name : "${var.name_prefix}-linux-vm"
  vpc_network_name = var.vpc_network_name != null ? var.vpc_network_name : "${var.name_prefix}-private"
}

# VPC и подсети
module "net" {
  source = "github.com/terraform-yc-modules/terraform-yc-vpc.git?ref=19a9893f25b2536cea3c9c15c180c905ea37bf9c"
  network_name = local.vpc_network_name
  create_sg    = false
  public_subnets = [
    {
      zone           = var.zone
      v4_cidr_blocks = ["10.121.0.0/16"]
      name           = var.zone
    }
  ]
}

# Создание boot-дисков
resource "yandex_compute_disk" "boot_disk" {
  for_each = toset([for i in range(var.instance_count) : tostring(i)])

  name     = "${var.name_prefix}-boot-disk-${each.key}"
  zone     = var.zone
  image_id = var.image_id

  type = var.instance_resources.disk.disk_type
  size = var.instance_resources.disk.disk_size
}

resource "yandex_vpc_address" "static_ip" {
  for_each = toset([for i in range(var.instance_count) : tostring(i)])

  name = "${var.name_prefix}-static-ip-${each.key}"

  external_ipv4_address {
    zone_id = var.zone
  }
}


# Виртуальные машины
resource "yandex_compute_instance" "this" {
  for_each    = toset([for i in range(var.instance_count) : tostring(i)])

  name        = "${var.name_prefix}-linux-vm-${each.key}"
  platform_id = var.instance_resources.platform_id
  zone        = var.zone

  resources {
    cores         = var.instance_resources.cores
    memory        = var.instance_resources.memory
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    device_name = "root"
    mode        = "READ_WRITE"
    disk_id     = yandex_compute_disk.boot_disk[each.key].id
  }

  network_interface {
    subnet_id      = values(module.net.public_subnets)[0].subnet_id
    nat            = true
    nat_ip_address = yandex_vpc_address.static_ip[each.key].external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }

  allow_stopping_for_update = true
}

