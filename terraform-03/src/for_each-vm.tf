resource "yandex_compute_instance" "loop2" {
  for_each  = {
    for vm in var.vms:
    vm.vm_name => vm
  }
  name        = "${each.value.vm_name}"
  platform_id = var.vm_platform_id
  resources {
    cores         = "${each.value.cpu}"
    memory        = "${each.value.ram}"
    core_fraction = var.vm_resources.frac
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = "${each.value.disk}"
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
    user-data          = "${file("./meta.yml")}"
    serial-port-enable = "${each.value.sport-enable}"
    ssh-keys           = local.ssh-keys
  }

  depends_on = [yandex_compute_instance.loop1]

}
