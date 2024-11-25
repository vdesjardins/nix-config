{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.terraform;
in {
  options.modules.shell.tools.terraform = {
    enable = mkEnableOption "terraform cli";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      terraform
    ];

    programs.zsh.shellAliases = {
      tf = "terraform";
      tfa = "terraform apply";
      tfat = "terraform apply -target=";
      tfp = "terraform plan";
      tfpt = "terraform plan -target=";
      tfi = "terraform init";
      tfsl = "terraform state list";
    };
  };
}
