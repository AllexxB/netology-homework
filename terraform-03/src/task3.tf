resource "yandex_compute_disk" "task3" {
  count      = 3
  name       = "hdd-${count.index}"
  type       = var.hdds.type
  zone       = var.default_zone
  size       = var.hdds.size
  block_size = var.hdds.block_size
}

resource "yandex_compute_instance" "vm-task3" {
  name        = "${var.vm_name}-task3-vm"
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.mem
    core_fraction = var.vm_resources.frac
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic secondary_disk {
    for_each = "${yandex_compute_disk.task3.*.id}"

    content {
      disk_id     = yandex_compute_disk.task3["${secondary_disk.key}"].id
    }

 }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = false
    security_group_ids = [
      "${yandex_vpc_security_group.example.id}"
    ]
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  depends_on = [
    yandex_compute_disk.task3,
    yandex_vpc_security_group.example,
    yandex_vpc_subnet.develop
  ]

}

