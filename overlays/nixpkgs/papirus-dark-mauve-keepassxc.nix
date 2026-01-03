# Override Papirus-Dark theme to use mauve (#b48ead) for KeePassXC system tray icons
inputs: _self: super: {
  papirus-icon-theme = super.papirus-icon-theme.overrideAttrs (old: {
    postFixup =
      (old.postFixup or "")
      + ''
        echo "Patching KeePassXC icons to use mauve color..."
        # Update KeePassXC SVG icons in Papirus-Dark to use mauve instead of light gray
        # The ColorScheme-Text is used by currentColor in the SVG
        # These are the real files that the monochrome-dark symlinks point to
        for size_dir in 16x16 22x22 24x24 32x32 48x48 64x64; do
          if [ -f "$out/share/icons/Papirus-Dark/$size_dir/panel/keepassxc-unlocked.svg" ]; then
            sed -i 's|\.ColorScheme-Text { color:#dfdfdf|.ColorScheme-Text { color:#b48ead|g' \
              "$out/share/icons/Papirus-Dark/$size_dir/panel/keepassxc-unlocked.svg"
          fi
          if [ -f "$out/share/icons/Papirus-Dark/$size_dir/panel/keepassxc-locked.svg" ]; then
            sed -i 's|\.ColorScheme-Text { color:#dfdfdf|.ColorScheme-Text { color:#b48ead|g' \
              "$out/share/icons/Papirus-Dark/$size_dir/panel/keepassxc-locked.svg"
          fi
        done
        echo "Done patching KeePassXC icons"
      '';
  });
}
