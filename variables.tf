variable "name_prefix" {
  description = "(Optional) - Name prefix for project."
  type        = string
  default     = "project"
}

variable "boot_disk_name" {
  description = "(Optional) - Name of the boot disk."
  type        = string
  default     = null
}

variable "linux_vm_name" {
  description = "(Optional) - Name of the Linux VM."
  type        = string
  default     = null
}

variable "vpc_network_name" {
  description = "(Optional) - Name of the VPC network."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "(Optional) - Yandex Cloud Folder ID where resources will be created."
  type        = string
}

variable "instance_count" {
  type        = number
  default     = 3
  description = "Количество создаваемых экземпляров"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона доступности для всех экземпляров"
}

variable "instance_resources" {
  type = object({
    platform_id = string
    cores       = number
    memory      = number
    disk = optional(object({
      disk_type = string
      disk_size = number
    }))
  })
  default = {
    platform_id = "standard-v3"
    cores       = 2
    memory      = 4
    disk = {
      disk_type = "network-ssd"
      disk_size = 30
    }
  }
  description = "Ресурсы для каждого экземпляра"
}

variable "ssh_public_key" {
  type        = string
  description = "Путь к файлу публичного SSH-ключа"
}

variable "ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Имя пользователя SSH для доступа к экземплярам"
}

variable "image_id" {
  type        = string
  default     = "fd83m7rp3r4l12c2keph"
  description = "ID образа для загрузочного диска"
}