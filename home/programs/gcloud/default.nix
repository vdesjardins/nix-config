{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
  mkMerge [
    (
      mkIf config.programs.zsh.enable {
        home.packages = with pkgs.unstable; [
          (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
        ];

        home.sessionVariables = {
          USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
        };

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
