{
  lib,
  master,
  fetchFromGitHub,
  versionCheckHook,
}:
# Upstream requires Go 1.27.4; unstable still provides 1.27.3.
master.buildGo127Module rec {
  pname = "github-mcp-server";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-/AR6edAJT1WrHEoYvBgh9rQz1EhWMn1acbFcZPEwom4=";
  };

  vendorHash = "sha256-xe11l2K2Zg1PmXEbnnPlIVHcOZJ0ucOpjq5ygJnxQUU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
    "-X main.date=unknown"
  ];
  nativeInstallCheckInputs = [versionCheckHook];
  doInstallCheck = true;

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
