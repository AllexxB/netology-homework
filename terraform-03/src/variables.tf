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
  description = "VPC network&subnet name"
}
variable "vm_image_family" {
  type = string
  default =   "ubuntu-2004-lts"
  description = "image_for_install"
 }
 variable "vm_resources" {
  type        = map
  default     = {
    cores     = 2,
    mem       = 2,
    frac      = 20
  }
}
variable "vm_platform_id" {
  type = string
  default =   "standard-v1"
  description = "platform_id"
}
variable "vm_name" {
  type = string
  default =   "terraform"
  description = "name_for_instance"
 }
 variable "vms" {
  type        = list(object({
    vm_name       = string,
    cpu           = number,
    ram           = number,
    disk          = number,
    sport-enable  = number}))
     default = [
    {
      vm_name = "vm-01"
      cpu   = 2
      ram   = 1
      disk  = 10
      sport-enable = 1
    },
    {
      vm_name = "vm-02"
      cpu   = 2
      ram   = 2
      disk  = 20
      sport-enable = 1
    },
   ]

}
variable "hdds" {
  type        = map
  default     = {
    type       = "network-hdd",
    size       = 1,
    block_size = 4096,
  }
}