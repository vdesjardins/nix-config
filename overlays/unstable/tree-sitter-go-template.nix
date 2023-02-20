# From: https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/parsing/tree-sitter/default.nix
inputs: _self: super: {
  tree-sitter-grammars = super.tree-sitter-grammars // {
    tree-sitter-gotmpl = super.stdenv.mkDerivation
      {
        name = "tree-sitter-gotmpl";

        src = inputs.tree-sitter-go-template;

        # nativeBuildInputs = super.lib.optionals generate [ nodejs tree-sitter ];

        CFLAGS = [ "-Isrc" "-O2" ];
        CXXFLAGS = [ "-Isrc" "-O2" ];

        stripDebugList = [ "parser" ];

        # configurePhase = lib.optionalString generate ''
        #   tree-sitter generate
        # '' + lib.optionalString (location != null) ''
        #   cd ${location}
        # '';

        # When both scanner.{c,cc} exist, we should not link both since they may be the same but in
        # different languages. Just randomly prefer C++ if that happens.
        buildPhase = ''
          runHook preBuild
          if [[ -e src/scanner.cc ]]; then
            $CXX -fPIC -c src/scanner.cc -o scanner.o $CXXFLAGS
          elif [[ -e src/scanner.c ]]; then
            $CC -fPIC -c src/scanner.c -o scanner.o $CFLAGS
          fi
          $CC -fPIC -c src/parser.c -o parser.o $CFLAGS
          rm -rf parser
          $CXX -shared -o parser *.o
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir $out
          mv parser $out/
          if [[ -d queries ]]; then
            cp -r queries $out
          fi
          runHook postInstall
        '';
      };
  };
}
