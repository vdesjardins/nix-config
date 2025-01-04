{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.nix-function-calls;
in {
  options.modules.shell.tools.nix-function-calls = {
    enable = mkEnableOption "nix-function-calls";
  };

  config = mkIf cfg.enable {
    home.packages = let
      # https://discourse.nixos.org/t/nix-flamegraph-or-profiling-tool/33333
      stack-collapse =
        pkgs.writeScript "stack-collapse"
        (builtins.readFile (builtins.fetchurl
          {
            url = "https://raw.githubusercontent.com/NixOS/nix/master/contrib/stack-collapse.py";
            sha256 = "sha256:0mi9cf3nx7xjxcrvll1hlkhmxiikjn0w95akvwxs50q270pafbjw";
          }));
      generate-flamegraph = pkgs.writeShellScript "generate-flamegraph" ''
        WORKDIR=$1

        ${stack-collapse} "$WORKDIR"/nix-function-calls.trace >"$WORKDIR"/nix-function-calls.folded
        ${pkgs.inferno}/bin/inferno-flamegraph "$WORKDIR"/nix-function-calls.folded >"$WORKDIR"/nix-function-calls.svg
        echo "$WORKDIR/nix-function-calls.svg"
      '';
      nix-trace-eval = pkgs.writeShellScriptBin "nix-trace-eval" ''
        WORKDIR=$(mktemp -d)

        nix eval -vvvvvvvvvvvvvvvvvvvv --raw --option trace-function-calls true "$@" 1>/dev/null 2>"$WORKDIR"/nix-function-calls.trace
        ${generate-flamegraph} "$WORKDIR"
      '';
      nix-trace-shell = pkgs.writeShellScriptBin "nix-trace-shell" ''
        WORKDIR=$(mktemp -d)

        nix env shell -vvvvvvvvvvvvvvvvvvvv --option trace-function-calls true "$@" 1>/dev/null 2>"$WORKDIR"/nix-function-calls.trace
        ${generate-flamegraph} "$WORKDIR"
      '';
    in [nix-trace-shell nix-trace-eval];
  };
}
