{ ... }:
let
  crossSystems = [ "aarch64-linux" ];
in
{
  services.nix-daemon.enable = true;

  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "localhost";
        systems = crossSystems;
        sshUser = "builder";
        sshKey = "/etc/nix/builder_ed25519";
        maxJobs = 4;
        supportedFeatures = [ "kvm" "big-parallel" ];
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
      }
    ];

    settings = {
      trusted-users = [ "@admin" ];
    };
  };
}
