resource "proxmox_virtual_environment_vm" "this" {
  name        = var.name

  node_name = var.node_name
  started = true

  cpu {
    cores        = var.cpu
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = var.memory
    floating = var.memory
  }

  disk {
    file_id      = "local:iso/${var.iso}"
    interface    = "scsi0"
    size = var.volume_size
    aio = "native"
    replicate = false
    backup = false
    discard = "ignore"
    ssd = false
    cache = "none"
    iothread = true
  }
  scsi_hardware = "virtio-scsi-single"

  initialization {
    dns {
      servers = var.dns
    }
    ip_config {
      ipv4 {
        address = var.ip.address
        gateway = var.ip.gateway
      }
    }
  }

  operating_system {
    type = "l26"
  }

  network_device {
    mac_address = var.mac_address
  }
}