###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOOMyBeismFih5iMhX91kTtjLuajQ+zZAnX0Y3kZtQpGPXRPKhbDSZ2LlxkwsrtWwh8u9Jdyehw0JqrkVefVBq1qlDL9/9WHDuSqU1r1FN09ZgVKmPmth4h1aMpPiAPO7vAFphiAcyzno6/EvSDOqbAaUScBZDbPTg3GdhdTwLqGxCu9ppx4yYLmYoBkgOb7kCJhqUsNYfLvBx4bKi+YsQXEYQ/JAWX3ZpBnLhUuvQG/Y1o5xYMDp0/H3hpUl4EBm09c/fLX/yrSJWmY286MeWEyY9hxldWerkm4PvArSo2U1Yd0xK7yvi9k1XseXL+NdOxOuE2xnUiU8iX7YYzdQiIfAeBwjD1xc4OZEJIEFoKUDpBfMzMhVUycEYGC8zjKAayAxPO/5rHe97hdyF3PM7ODEfvmc+Cpttel/8jd9+DYZ8aYPHrVes/AN6qXWMN8eclvNajmxlosbeM4OejQv06o/8AL/KV6lapLsjLRnTC6syfCh/jBz2nyxF0FBUCM8="
#  description = "ssh-keygen -t ed25519"
#}
 ### lesson 2
 
 variable "vm_web_family" {
  type = string
  default =   "ubuntu-2004-lts"
  description = "image_for_install"
 }

variable "vm_web_name" {
  type = string
  default =   "develop"
  description = "name_for_instance"
 }

 variable "vm_web_platform_id" {
  type = string
  default =   "standard-v1"
  description = "platform_id"
 }
 variable "vm_db_family" {
  type = string
  default =   "ubuntu-2004-lts"
  description = "image_for_install"
 }

variable "vm_db_name" {
  type = string
  default =   "develop"
  description = "name_for_instance"
 }

 variable "vm_db_platform_id" {
  type = string
  default =   "standard-v1"
  description = "platform_id"
 }
variable "vm_web_resources" {
  type        = map
  default     = {
    cores     = 2,
    mem       = 1,
    frac      = 5
  }
}

variable "vm_db_resources" {
  type        = map
  default     = {
    cores     = 2,
    mem       = 2,
    frac      = 20
  }
}

variable "vm_metadata" {
  type        = map
  default     = {
    serial-port-enable     = 1,
    ssh-keys       = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOOMyBeismFih5iMhX91kTtjLuajQ+zZAnX0Y3kZtQpGPXRPKhbDSZ2LlxkwsrtWwh8u9Jdyehw0JqrkVefVBq1qlDL9/9WHDuSqU1r1FN09ZgVKmPmth4h1aMpPiAPO7vAFphiAcyzno6/EvSDOqbAaUScBZDbPTg3GdhdTwLqGxCu9ppx4yYLmYoBkgOb7kCJhqUsNYfLvBx4bKi+YsQXEYQ/JAWX3ZpBnLhUuvQG/Y1o5xYMDp0/H3hpUl4EBm09c/fLX/yrSJWmY286MeWEyY9hxldWerkm4PvArSo2U1Yd0xK7yvi9k1XseXL+NdOxOuE2xnUiU8iX7YYzdQiIfAeBwjD1xc4OZEJIEFoKUDpBfMzMhVUycEYGC8zjKAayAxPO/5rHe97hdyF3PM7ODEfvmc+Cpttel/8jd9+DYZ8aYPHrVes/AN6qXWMN8eclvNajmxlosbeM4OejQv06o/8AL/KV6lapLsjLRnTC6syfCh/jBz2nyxF0FBUCM8="
  }
}