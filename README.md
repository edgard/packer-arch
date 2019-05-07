# packer-arch

Packer template to create VirtualBox OVA image with a base Arch Linux installation.

I do not recommend using it as-is, fork and make your changes before using it. You've been warned!

## Configuration

Edit the template **arch.json** to configure default user, zoneinfo and country.

### Build

Run ```packer build arch.json```
