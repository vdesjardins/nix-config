# Notes

## Linux

NSCD must be installed on the OS to be able to use server NSS components. You need this for example on GCP when using OS Login.

[Reference](https://github.com/NixOS/nixpkgs/issues/36297)

```
apt install nscd
systemctl enable nscd
systemctl start nscd
```
