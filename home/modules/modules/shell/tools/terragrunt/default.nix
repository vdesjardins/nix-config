{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.terragrunt;
in {
  options.modules.shell.tools.terragrunt = {
    enable = mkEnableOption "terragrunt cli";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      terragrunt
    ];

    programs.zsh.shellAliases = {
      tg = "terragrunt";
      tga = "terragrunt apply";
      tgat = "terragrunt apply -target=";
      tgp = "terragrunt plan -lock=false";
      tgpt = "terragrunt plan -lock=false -target=";
      tgi = "terragrunt init";
      tgiu = "terragrunt init -upgrade";
      tgsl = "terragrunt state list";
      tgv = "terragrunt validate";
    };
  };
}
