# raid in rescue
mdadm --examine --scan >> /etc/mdadm.conf
mdadm --assemble --scan /dev/md0

# Если нет LVM
mount /dev/md0 /mnt

# Если есть LVM
pvscan
vgscan
vgchange -ay
mount /dev/mapper/vg0-root /mnt
