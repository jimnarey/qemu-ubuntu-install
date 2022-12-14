
qemu-system-x86_64 -enable-kvm -bios /usr/share/OVMF/OVMF_CODE.fd -drive file=./output-custom_image/ubuntu-22.04 -m 2048

qemu-system-x86_64 -enable-kvm -cpu host -smp cores=2 -device e1000,netdev=user.0 -machine type=pc,accel=kvm -netdev user,id=user.0,hostfwd=tcp::2226-:22 -bios /usr/share/OVMF/OVMF_CODE.fd -drive file=./output-custom_image/ubuntu-22.04 -m 2048

------------------------

qemu-system-x86_64 -enable-kvm -cpu host -smp cores=2 -machine type=pc,accel=kvm -net user,hostfwd=tcp::10022-:22 -net nic -bios /usr/share/OVMF/OVMF_CODE.fd -drive file=./output-custom_image/ubuntu-22.04 -m 2048

ssh admin@localhost -p 10022