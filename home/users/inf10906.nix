{...}: {
  home = {
    username = "inf10906";
    homeDirectory = "/Users/inf10906";
    stateVersion = "23.11";
  };

  roles.common.enable = true;
  roles.darwin.enable = true;
  roles.security.enable = true;
  roles.nixpkgs.enable = true;
  roles.utils.enable = true;

  roles.dev.bash.enable = true;
  roles.dev.go.enable = true;
  roles.dev.json.enable = true;
  roles.dev.lua.enable = true;
  roles.dev.make.enable = true;
  roles.dev.markdown.enable = true;
  roles.dev.nix.enable = true;
  roles.dev.python.enable = true;
  roles.dev.rego.enable = true;
  roles.dev.rust.enable = true;
  roles.dev.terraform.enable = true;
  roles.dev.yaml.enable = true;

  roles.ops.aws.enable = true;
  roles.ops.gcloud.enable = true;
  roles.ops.container.enable = true;
  roles.ops.k8s.enable = true;
  roles.ops.networking.enable = true;
  roles.ops.vault.enable = true;

  roles.ai.opencode.enable = true;
  roles.ai.codex.enable = true;
  roles.ai.github-copilot-cli.enable = true;
  roles.ai.mcp.context7.enable = true;
  roles.ai.mcp.desktop-commander.enable = true;
  roles.ai.mcp.fetch.enable = true;
  roles.ai.mcp.git.enable = true;
  roles.ai.mcp.github.enable = true;
  roles.ai.mcp.sequential-thinking.enable = true;
  roles.ai.mcp.kubernetes.enable = true;

  roles.desktop.darwin.enable = true;
  roles.desktop.browsers.enable = true;

  modules.desktop.editors.nixvim = {
    ai = {
      chat = {
        adapter = {
          name = "copilot";
          model = "gemini-2.5-pro";
        };
      };
      agent = {
        adapter = {
          name = "copilot";
          model = "gemini-2.5-pro";
        };
      };
      inline = {
        adapter = {
          name = "copilot";
          model = "gemini-2.5-pro";
        };
      };
    };
  };
}
