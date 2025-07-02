{lib, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/home/vince";
    stateVersion = "24.11";
  };

  roles.common.enable = true;
  roles.vaults.enable = true;
  roles.utils.enable = true;
  roles.nixpkgs.enable = true;
  roles.sync.enable = true;
  roles.security.enable = true;
  roles.multimedia.enable = true;

  roles.dev.bash.enable = true;
  roles.dev.cue.enable = true;
  roles.dev.kcl.enable = true;
  roles.dev.debugging.enable = true;
  roles.dev.go.enable = true;
  roles.dev.js.enable = true;
  roles.dev.json.enable = true;
  roles.dev.lua.enable = true;
  roles.dev.make.enable = true;
  roles.dev.markdown.enable = true;
  roles.dev.nix.enable = true;
  roles.dev.python.enable = true;
  roles.dev.rust.enable = true;
  roles.dev.terraform.enable = true;
  roles.dev.yaml.enable = true;
  roles.dev.zig.enable = true;
  roles.ops.aws.enable = true;
  roles.ops.container.enable = true;
  roles.ops.k8s.enable = true;
  roles.ops.networking.enable = true;
  roles.ops.bpf.enable = true;

  roles.ai.ollama.enable = true;
  roles.ai.gemini-cli.enable = true;
  roles.ai.mcp.context7.enable = true;
  roles.ai.mcp.desktop-commander.enable = true;
  roles.ai.mcp.fetch.enable = true;
  roles.ai.mcp.git.enable = true;
  roles.ai.mcp.github.enable = true;
  roles.ai.mcp.kubernetes.enable = true;
  roles.ai.mcp.serena.enable = true;

  roles.desktop.wallpapers.enable = true;
  roles.desktop.browsers.enable = true;
  roles.desktop.viewers.enable = true;
  roles.desktop.security.enable = true;
  roles.desktop.sway.enable = true;
  roles.desktop.gaming.enable = true;
  roles.desktop.productivity.enable = true;
  roles.desktop.wifi.enable = true;
  roles.desktop.diagnostic.enable = true;
  roles.desktop.graphics.enable = true;
  roles.desktop.videos.enable = true;
  roles.desktop.messaging.enable = true;
}
