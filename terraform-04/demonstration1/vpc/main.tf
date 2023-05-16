terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_vpc_network" "develop" {
  name = "develop"
}

resource "yandex_vpc_subnet" "develop" {
  name           = "develop-${var.zone}"
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

output "vpc_id" {
 value = yandex_vpc_network.develop.id
}

output "subnet_id" {
  value =  yandex_vpc_subnet.develop.id
}

output "vpc_zones" {
  value = yandex_vpc_subnet.develop.zone
}
