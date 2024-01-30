{
  deploy-rs,
  lib,
  self,
  ...
}: let
  inherit (lib.strings) hasSuffix;

  mkDeployNode = {
    system,
    hostname,
    sshUser ? "vince",
    user ? null,
  }: let
    os =
      if hasSuffix "linux" system
      then "nixos"
      else "darwin";
  in {
    inherit hostname;
    sshUser = user;

    profiles = {
      system = {
        user = "root";
        path = deploy-rs.lib.${system}.activate.${os} self."${os}Configurations".${hostname};
      };
      home = {
        inherit user;
        path = deploy-rs.lib.${system}.activate.home-manager self.homeConfigurations."${user}@${hostname}";
      };
    };
  };
in {
  remoteBuild = true;
  fastConnection = true;

  nodes = {
    V07P6L7R6H = mkDeployNode {
      system = "aarch64-darwin";
      hostname = "V07P6L7R6H";
      user = "inf10906";
    };

    dev-mac = mkDeployNode {
      system = "aarch64-darwin";
      hostname = "dev-mac";
      user = "vince";
    };

    dev-vm = mkDeployNode {
      system = "aarch64-linux";
      hostname = "dev-vm";
      user = "vince";
    };

    home-server = mkDeployNode {
      system = "aarch64-linux";
      hostname = "home-server";
      user = "admin";
    };
  };
}
