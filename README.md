# My Nix Dotfiles Config

![Build Nix envs](https://github.com/vdesjardins/nix-dotfiles/workflows/Build%20Nix%20envs/badge.svg)

## Initial Setup

### Mac

Install Nix:

```bash
make darwin/install
```

Source nix in the current shell:

```
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
make hm/vince
```

### Linux

TODO

## Linux/Home-Manager

NSCD must be installed on the OS to be able to use server NSS components. You need this for example on GCP when using OS Login.

[Reference](https://github.com/NixOS/nixpkgs/issues/36297)

```
apt install nscd
systemctl enable nscd
systemctl start nscd
```
