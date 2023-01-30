# Create template for cloud-init

```bash
qm create 900 --memory 2048 --sockets 2 --cores 1 --cpu cputype=host --name ubuntu-2004 --net0 e1000,bridge=vmbr0
qm importdisk 900 focal-server-cloudimg-amd64.img data --format qcow2
qm set 900 --scsihw virtio-scsi-pci --scsi0 data:900/vm-900-disk-0.qcow2
qm set 900 --ide2 data:cloudinit
qm set 900 --boot c --bootdisk scsi0
qm set 900 --serial0 socket --vga serial0
qm template 900
```

# create user
pveum user add admin@pve -comment "Admin user"
pveum passwd admin@pve
pveum group add admins -comment "System Administrators"
pveum acl modify / -group admins -role Administrator
pveum user modify admin@pve -group admin
