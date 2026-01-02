# nix-config Documentation

This directory contains comprehensive documentation for the nix-config project.

## Documentation Index

### [KeePassXC Integration Setup Guide](./KEEPASSXC-SETUP-GUIDE.md)

Complete setup guide for integrating KeePassXC with your nix-config system.
This is the primary resource for implementing credential management with:

- **D-Bus Secret Service Integration**: Automatic credential storage and
  retrieval for desktop applications
- **YubiKey Challenge-Response**: Hardware-backed authentication using YubiKey
  Slot 2 (HMAC-SHA1)
- **Git Version Control**: Automatic database backups with debounced commits
  (0-2 commits per session)
- **Syncthing Sync**: Cross-machine synchronization of your KeePassXC database
- **Auto-Lock**: Automatic locking on screen lock or 5-minute idle timeout
- **Fluffychat Integration**: Matrix client credential auto-fill from
   KeePassXC

**Status**: Ready for deployment
**Implementation Date**: January 2, 2026

#### Quick Start

Follow the 8-phase setup process:

1. **Phase 1**: YubiKey Configuration (one-time per key)
2. **Phase 2**: Initialize KeePassXC Database with git repo
3. **Phase 3**: Configure Syncthing for cross-machine sync
4. **Phase 4**: Deploy with home-manager
5. **Phase 5**: Test Fluffychat integration
6. **Phase 6**: Verify auto-commit functionality
7. **Phase 7**: Verify auto-lock functionality
8. **Phase 8**: Test cross-machine synchronization

#### Key Sections

- **Prerequisites**: Requirements before starting
- **Step-by-Step Setup**: Detailed instructions for each phase
- **Troubleshooting**: Solutions for common issues
- **Maintenance**: Regular backup and password change procedures
- **Security Notes**: Best practices and security considerations
- **Additional Resources**: Links to relevant documentation

#### Files Modified/Created

The implementation adds the following structure to your nix-config:

```text
home/modules/modules/desktop/
├── tools/keepassxc/
│   ├── default.nix              # Main module (options, imports)
│   ├── systemd-timer.nix        # Debounced auto-commit
│   └── xdg-autostart.nix        # XDG autostart configuration
└── messaging/
    └── fluffychat.nix           # Fluffychat module

home/modules/roles/desktop/
└── security.nix                 # Updated with KeePassXC + Fluffychat
```

#### Configuration Overview

| Setting | Value | Customizable |
|---------|-------|--------------|
| Database Path | `~/.local/share/keepassxc/database.kdbx` | No |
| Config Path | `~/.config/keepassxc/keepassxc.ini` | No |
| Git Remote | `git@github.com:vdesjardins/keepassxc-vault.git` | No (hardcoded) |
| Auto-Lock Idle | 300 seconds (5 minutes) | No |
| Auto-Lock Screen | On screen lock | No |
| D-Bus Secret Service | Always enabled | No |
| Debounce Window | 60 seconds | No |
| YubiKey Slot | Slot 2 (HMAC-SHA1) | No |

#### Next Steps

1. **Manual Pre-Implementation** (see Phase 1-3 in setup guide):
   - Configure YubiKeys with challenge-response
   - Create and test KeePassXC database
   - Initialize git repository and first commit
   - Configure Syncthing folder with ignore patterns

2. **Deploy**:
   - Enable `roles.desktop.security.enable = true` in your user config
   - Run `home-manager switch`

3. **Test**:
   - Follow testing checklist in Phases 5-8
   - Verify systemd services running
   - Check git auto-commit and Syncthing sync

---

## Project Information

- **Repository**: /home/vince/projects/nix-config
- **Language**: Nix
- **Last Updated**: January 2, 2026

For questions or issues, check the KEEPASSXC-SETUP-GUIDE.md troubleshooting
section.
