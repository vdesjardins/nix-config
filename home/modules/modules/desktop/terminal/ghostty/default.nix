{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool package str;
  inherit (pkgs.stdenv) isLinux;

  cfg = config.modules.desktop.terminal.ghostty;
  ghosttyPkg = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  options.modules.desktop.terminal.ghostty = {
    enable = mkEnableOption "ghostty";
    font = mkOption {
      type = str;
    };
    font-italic = mkOption {
      type = str;
    };
    font-bold = mkOption {
      type = str;
    };
    font-bold-italic = mkOption {
      type = str;
    };
    theme = mkOption {
      type = str;
    };
    useTmux = mkOption {
      type = bool;
      default = false;
    };
    package = mkOption {
      type = package;
      default = ghosttyPkg;
    };
  };

  config = mkIf cfg.enable (let
    keybindsStandalone = ''
      # splits
      keybind = ctrl+space>v=new_split:right
      keybind = ctrl+space>s=new_split:down

      keybind = alt+h=resize_split:left,50
      keybind = alt+k=resize_split:up,50
      keybind = alt+j=resize_split:down,50
      keybind = alt+l=resize_split:right,50

      keybind = ctrl+h=goto_split:left
      keybind = ctrl+k=goto_split:top
      keybind = ctrl+j=goto_split:bottom
      keybind = ctrl+l=goto_split:right

      keybind = ctrl+space>equal=equalize_splits

      keybind = ctrl+a>p=goto_split:previous
      keybind = ctrl+a>n=goto_split:next

      keybind = ctrl+space>z=toggle_split_zoom

      # tabs
      keybind = alt+one=goto_tab:1
      keybind = alt+two=goto_tab:2
      keybind = alt+three=goto_tab:3
      keybind = alt+four=goto_tab:4
      keybind = alt+five=goto_tab:5
      keybind = alt+six=goto_tab:6
      keybind = alt+seven=goto_tab:7
      keybind = alt+eight=goto_tab:8
      keybind = alt+nine=goto_tab:9
      keybind = ctrl+space>p=previous_tab
      keybind = ctrl+shift+tab=previous_tab
      keybind = ctrl+shift+left=previous_tab
      keybind = ctrl+space>n=next_tab
      keybind = ctrl+tab=next_tab
      keybind = ctrl+shift+right=next_tab
      keybind = ctrl+space>c=new_tab

      # selection
      keybind = ctrl+shift+v=paste_from_clipboard
      keybind = shift+insert=paste_from_selection
      keybind = ctrl+shift+a=select_all
      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = shift+left=adjust_selection:left
      keybind = shift+right=adjust_selection:right
      keybind = shift+up=adjust_selection:up
      keybind = shift+down=adjust_selection:down
      keybind = ctrl+shift+j=write_scrollback_file:paste
      keybind = ctrl+alt+shift+j=write_scrollback_file:open

      # window
      keybind = ctrl+shift+n=new_window
      keybind = ctrl+enter=toggle_fullscreen
      keybind = alt+f4=close_window

      # scrolling
      keybind = shift+page_up=scroll_page_up
      keybind = shift+end=scroll_to_bottom
      keybind = shift+home=scroll_to_top
      keybind = shift+page_down=scroll_page_down
      keybind = ctrl+shift+page_down=jump_to_prompt:1
      keybind = ctrl+shift+page_up=jump_to_prompt:-1
    '';

    keybindsTmux = '''';
  in {
    home.packages =
      if isLinux
      then [ghosttyPkg]
      else [];

    xdg.configFile."ghostty/config".text = ''
      font-size = 13.3
      font-thicken = true
      font-family = "${cfg.font}"
      font-family-italic = "${cfg.font-italic}"
      font-family-bold = "${cfg.font-bold}"
      font-family-bold-italic = "${cfg.font-bold-italic}"
      font-feature = ss01
      font-feature = ss02
      font-feature = ss03
      font-feature = ss04
      font-feature = ss05
      font-feature = ss06
      font-feature = ss07
      font-feature = ss08
      font-feature = ss09
      font-feature = calt
      font-feature = dlig
      font-feature = liga

      theme = "${cfg.theme}"

      bold-is-bright = true

      gtk-tabs-location = bottom
      gtk-single-instance = false

      shell-integration = zsh

      copy-on-select = clipboard
      focus-follows-mouse = true

      quick-terminal-position = bottom
      quick-terminal-autohide = true
      keybind = global:cmd+/=toggle_quick_terminal

      # we keep alt-right as a alt-graph key for typing special characters
      macos-option-as-alt = left

      desktop-notifications = true

      # font sizing
      keybind = ctrl+plus=increase_font_size:1
      keybind = ctrl+equal=increase_font_size:1
      keybind = ctrl+minus=decrease_font_size:1
      keybind = ctrl+zero=reset_font_size

      # misc
      keybind = ctrl+shift+w=close_surface
      keybind = ctrl+shift+q=quit
      keybind = ctrl+shift+v=paste_from_clipboard

      # config / debugging
      keybind = ctrl+comma=open_config
      keybind = ctrl+shift+comma=reload_config
      keybind = ctrl+shift+i=inspector:toggle

      ${
        if cfg.useTmux
        then keybindsTmux
        else keybindsStandalone
      }
    '';
  });
}
