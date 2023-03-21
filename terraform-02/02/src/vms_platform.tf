
resource "yandex_compute_instance" "platform" {
  name        = "${var.vm_web_name}"
  platform_id = "${var.vm_web_platform_id}"
  resources {
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.mem
    core_fraction = var.vm_web_resources.frac
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vm_metadata.serial-port-enable}"
    ssh-keys           = "${var.vm_metadata.ssh-keys}"
  }

}
resource "yandex_compute_instance" "platform2" {
  name        = "${var.vm_db_name}"
  platform_id = "${var.vm_db_platform_id}"
  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.mem
    core_fraction = var.vm_db_resources.frac
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vm_metadata.serial-port-enable}"
    ssh-keys           = "${var.vm_metadata.ssh-keys}"
  }

}