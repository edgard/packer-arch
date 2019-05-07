#!/bin/bash -x

# -----------------------------------------------------------------------------
# system cleanup
# -----------------------------------------------------------------------------
cat <<'EOF' >/mnt/run.sh
usermod -L root
yes | pacman -Scc
rm -rf /tmp/*
rm -rf /var/lib/dhcp/*
rm -rf /root/.ssh
unset HISTFILE
rm -f /root/.bash_history
find /var/log -type f | while read f; do echo -ne '' > "${f}"; done;
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp
rm -rf /dev/.udev/
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm -f /tmp/whitespace
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
rm -f /boot/whitespace
EOF

chmod +x /mnt/run.sh
arch-chroot /mnt /run.sh
rm /mnt/run.sh
