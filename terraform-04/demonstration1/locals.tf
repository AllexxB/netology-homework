locals {
  ssh_user = "ubuntu"
}

locals {
  ssh_key = file("~/.ssh/id_rsa.pub")
}
