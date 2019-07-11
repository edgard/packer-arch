#!/bin/bash -x

# -----------------------------------------------------------------------------
# install config
# -----------------------------------------------------------------------------
CONFIG_DISK="/dev/sda"
CONFIG_HOSTNAME="arch"

# -----------------------------------------------------------------------------
# update mirrorlist
# -----------------------------------------------------------------------------
MIRRORLIST="https://www.archlinux.org/mirrorlist/?country=${CONFIG_COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"
curl -s "${MIRRORLIST}" | sed 's/^#Server/Server/' >/etc/pacman.d/mirrorlist

# -----------------------------------------------------------------------------
# system install
# -----------------------------------------------------------------------------
timedatectl set-ntp true
sgdisk --zap ${CONFIG_DISK}
dd if=/dev/zero of=${CONFIG_DISK} bs=512 count=2048
wipefs --all ${CONFIG_DISK}
sgdisk -n 1:0:0 -c 1:"root" -t 1:8300 ${CONFIG_DISK}
sgdisk ${CONFIG_DISK} -A 1:set:2
mkfs.ext4 -O ^64bit -F -m 0 -q ${CONFIG_DISK}1
mount ${CONFIG_DISK}1 /mnt
pacstrap /mnt base base-devel
genfstab -U /mnt >>/mnt/etc/fstab

cat <<EOF >/mnt/run.sh
pacman -S --needed --noconfirm openssh syslinux gptfdisk
ln -sf /usr/share/zoneinfo/${CONFIG_ZONEINFO} /etc/localtime
sed '/^#en_US\.UTF-8/ s/^#//' -i /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo "${CONFIG_HOSTNAME}" > /etc/hostname
echo "127.0.1.1	${CONFIG_HOSTNAME}.localdomain	${CONFIG_HOSTNAME}" >> /etc/hosts
mkinitcpio -p linux
useradd -m -p \$(openssl passwd -crypt "${CONFIG_USER}") ${CONFIG_USER}
usermod -a -G wheel ${CONFIG_USER}
sed '/^# %wheel ALL=(ALL) ALL/ s/^# //' -i /etc/sudoers
sed "s|sda3|${CONFIG_DISK##/dev/}1|" -i /boot/syslinux/syslinux.cfg
sed 's/TIMEOUT 50/TIMEOUT 5/' -i /boot/syslinux/syslinux.cfg
syslinux-install_update -iam
systemctl enable dhcpcd.service sshd.service
EOF

chmod +x /mnt/run.sh
arch-chroot /mnt /run.sh
rm /mnt/run.sh
