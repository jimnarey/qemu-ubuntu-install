variable "vm_template_name" {
  type    = string
  default = "ubuntu-22.04"
}

variable "ubuntu_iso_file" {
  type    = string
  default = "ubuntu-22.04.1-live-server-amd64.iso"
}

source "qemu" "custom_image" {

  # Boot Commands when Loading the ISO file with OVMF.fd file (Tianocore) / GrubV2
  boot_command = [
    "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<f10>"
  ]
  boot_wait = "5s"

  http_directory = "http"
  iso_url   = "https://releases.ubuntu.com/22.04.1/${var.ubuntu_iso_file}"
  # iso_checksum = "file://https://releases.ubuntu.com/22.04.1/SHA256SUMS"
  iso_checksum = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
  memory = 4096

  ssh_password = "packerubuntu"
  ssh_username = "admin"
  ssh_timeout = "20m"
  shutdown_command = "echo 'packerubuntu' | sudo -S shutdown -P now"

  headless = false # to see the process, In CI systems set to true
  accelerator = "kvm" # set to none if no kvm installed
  format = "qcow2"
  disk_size = "30G"
  cpus = 6

  qemuargs = [ # Depending on underlying machine the file may have different location
    ["-bios", "/usr/share/OVMF/OVMF_CODE.fd"]
  ] 
  vm_name = "${var.vm_template_name}"
}

build {
  sources = [ "source.qemu.custom_image" ]
  provisioner "shell" {
    inline = [ "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Cloud-Init...'; sleep 1; done" ]
  }
}