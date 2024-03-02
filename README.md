# My Nix Dotfiles Config

![Build Nix envs](https://github.com/vdesjardins/nix-dotfiles/workflows/Build%20Nix%20envs/badge.svg)

## Initial Setup

### Mac

Install Nix:

```bash
make darwin/install
```

Source nix in the current shell:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
```

Install Brew:

```bash
make darwin-install-brew
```

Configure system. In this case, my dev mac:

```bash
make config/dev-mac
```

Configure home-manager:

```bash
make hm/apply
```

## Preparing a new NixOS system

export ROOT_DISK=/dev/sda

## Create boot partition first

```bash
sudo parted -a opt --script "${ROOT_DISK}" \
    mklabel gpt \
    mkpart primary fat32 0% 512MiB \
    mkpart primary 512MiB 100% \
    set 1 esp on \
    name 1 boot \
    set 2 lvm on \
    name 2 root
```

### Set up boot partition

sudo mkfs.vfat -F32 /dev/disk/by-partlabel/boot

### Set up encrypted volume

```sh
sudo cryptsetup --type luks2 --cipher serpent-xts-plain64 --key-size 512 --hash sha512 luksFormat /dev/disk/by-partlabel/root
sudo cryptsetup luksOpen /dev/disk/by-partlabel/root root
```

### Set up disk partitions

```sh
sudo pvcreate /dev/mapper/root
sudo vgcreate main /dev/mapper/root

sudo lvcreate --size 40G --name nix-store main
sudo lvcreate --size 20G --name root main
sudo lvcreate --size "$(cat /proc/meminfo | grep MemTotal | cut -d':' -f2 | sed 's/ //g')" --name swap main
sudo lvcreate --extends 60%FREE --name home main

sudo vgchange --available y

sudo mkfs.ext4 -L nix-store /dev/mapper/main-nix--store
sudo mkfs.ext4 -L root /dev/mapper/main-root
sudo mkswap -L swap /dev/mapper/main-swap
sudo mkfs.ext4 -m 0 -L home /dev/mapper/main-home
```

### Mount filesystems

```sh
sudo mount /dev/disk/by-partlabel/root /mnt
sudo mkdir -p /mnt/nix/store
sudo mount /dev/mapper/main-nix--store /mnt/nix/store
sudo mkdir -p /mnt/home
sudo mount /dev/mapper/main-home /mnt/home
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-partlabel/boot
sudo swapon /dev/mapper/swap
```

### Generate config

```sh
nixos-generate-config --root /mnt
```

Afterwards you need to customize /mnt/etc/nixos/configuration.nix.

### Install

```sh
cd /mnt
sudo nixos-install
```
