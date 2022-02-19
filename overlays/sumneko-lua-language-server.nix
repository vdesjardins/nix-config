_inputs: _self: super: {
  sumneko-lua-language-server = super.sumneko-lua-language-server.overrideAttrs (old: rec {
    # version = "2.4.7";
    # src = super.pkgs.fetchFromGitHub {
    #   owner = "sumneko";
    #   repo = "lua-language-server";
    #   rev = version;
    #   sha256 = super.lib.fakeSha256;
    #   fetchSubmodules = true;
    # };
    # NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -stdlib=c++_static";
    # NIX_CFLAGS_COMPILE = super.pkgs.lib.optionalString super.stdenv.isDarwin "-I${super.pkgs.libcxx}/include/c++/v1";
    ninjaFlags = [
      "-fcompile/ninja/macos.ninja"
    ];
    nativeBuildInputs = old.nativeBuildInputs ++ (with super.pkgs;
      [ boost ]
    );
    buildInputs = with super.pkgs; [ boost ];
    # nativeBuildInputs = old.nativeBuildInputs ++ (with super.pkgs;
    #   [ clang_11 libcxx libcxxabi libinotify-kqueue boost.dev darwin.apple_sdk.frameworks.CoreServices ]
    # );
    # buildInputs = with super.pkgs; [ boost.dev ];
  });
}
