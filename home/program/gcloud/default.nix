{ pkgs, ... }:
with lib;

mkMerge [
  (
    mkIf config.programs.zsh.enable {
      home.packages = with pkgs; [
        google-cloud-sdk
      ];

      programs.zsh = {
        shellAliases = {
          gpl = "gcloud projects list";
        };
      };
      xdg.configFile."zsh/functions/gcp-project-id".source =
        ./zsh/functions/gcp-project-id;
      xdg.configFile."zsh/functions/gcp-list-ip".source =
        ./zsh/functions/gcp-list-ip;
    }
  )
]

