#!/bin/bash -x

# -----------------------------------------------------------------------------
# install vmware guest utils
# -----------------------------------------------------------------------------
cat <<'EOF' >/mnt/run.sh
pacman -S --needed --noconfirm open-vm-tools
systemctl enable vmtoolsd.service vmware-vmblock-fuse.service
EOF

chmod +x /mnt/run.sh
arch-chroot /mnt /run.sh
rm /mnt/run.sh
