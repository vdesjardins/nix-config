{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.terraform;
in {
  options.programs.terraform = {
    enable = mkEnableOption "terraform";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unstable.terraform
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
