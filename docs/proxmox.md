# Create template for cloud-init
# https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img  # 22.04
# https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img  # 20.04
```bash
qm create 900 --memory 2048 --sockets 2 --cores 1 --cpu cputype=host --name ubuntu-2004 --net0 e1000,bridge=vmbr0
qm importdisk 900 focal-server-cloudimg-amd64.img data --format qcow2
qm set 900 --scsihw virtio-scsi-pci --virtio0 data:900/vm-900-disk-0.qcow2
qm set 900 --ide2 data:cloudinit
qm set 900 --boot c --bootdisk virtio0
qm set 900 --serial0 socket --vga serial0
qm template 900
```

# create user
pveum user add admin@pve -comment "Admin user"
pveum passwd admin@pve
pveum group add admins -comment "System Administrators"
pveum acl modify / -group admins -role Administrator
pveum user modify admin@pve -group admins

# fsck for qcow2
modprobe nbd max_path=2
qemu-nbd --connect=/dev/nbd0 <path-to-qcow2>
fdisk -l /dev/nbd0
fsck -y /dev/nbd0
qemu-nbd --disconnect /dev/nbd0
