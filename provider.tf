# Провайдеры
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.35.0"
    }
    time = {
      source  = "hashicorp/time"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
}