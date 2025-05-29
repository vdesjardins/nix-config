{lib, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/Users/vince";
    stateVersion = "23.11";
  };

  roles.common.enable = true;
  roles.darwin.enable = true;
  roles.security.enable = true;
  roles.vaults.enable = true;
  roles.utils.enable = true;
  roles.nixpkgs.enable = true;
  roles.ai.enable = true;
  roles.sync.enable = true;

  roles.dev.bash.enable = true;
  roles.dev.cue.enable = true;
  roles.dev.debugging.enable = true;
  roles.dev.go.enable = true;
  roles.dev.go-template.enable = true;
  roles.dev.js.enable = true;
  roles.dev.json.enable = true;
  roles.dev.jq.enable = true;
  roles.dev.lua.enable = true;
  roles.dev.make.enable = true;
  roles.dev.markdown.enable = true;
  roles.dev.nix.enable = true;
  roles.dev.python.enable = true;
  roles.dev.regex.enable = true;
  roles.dev.rust.enable = true;
  roles.dev.terraform.enable = true;
  roles.dev.vimscript.enable = true;
  roles.dev.yaml.enable = true;
  roles.dev.zig.enable = true;

  roles.ops.aws.enable = true;
  roles.ops.container.enable = true;
  roles.ops.k8s.enable = true;
  roles.ops.networking.enable = true;
  roles.ops.virtualization.enable = true;
  roles.desktop.browsers.enable = true;
  roles.desktop.darwin.enable = true;
}
