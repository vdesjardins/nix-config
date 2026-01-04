{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.build;
in {
  options.roles.dev.build = {
    enable = mkEnableOption "build tools (make, cpp)";
    make.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable make build tools (checkmake)";
    };
    cpp.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable C/C++ build tools (gcc, clang, cmake, cppcheck, poco)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      (lib.optional cfg.make.enable checkmake)
      ++ (lib.optionals cfg.cpp.enable [
        clang-tools
        cmake
        cppcheck
        gcc
        poco
      ]);
  };
}
