#!/bin/bash -x

# -----------------------------------------------------------------------------
# install virtualbox guest utils
# -----------------------------------------------------------------------------
cat <<'EOF' >/mnt/run.sh
pacman -S --needed --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils-nox
systemctl enable vboxservice.service
EOF

chmod +x /mnt/run.sh
arch-chroot /mnt /run.sh
rm /mnt/run.sh
