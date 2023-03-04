inputs: _self: super: let
  languages =
    super.lib.listToAttrs
    (
      map
      (
        l: {
          name = l;
          value = {
            lang = super.lib.removePrefix "tree-sitter-grammars-" l;
          };
        }
      )
      (
        super.lib.filter (name: builtins.match "^tree-sitter-grammars-.*$" name != null)
        (super.lib.attrNames inputs)
      )
    )
    // {
      markdown = {
        lang = "markdown";
        location = "./tree-sitter-markdown";
      };
      markdown-inline = {
        lang = "markdown-inline";
        location = "./tree-sitter-markdown-inline";
      };
    };

  # From: https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/parsing/tree-sitter/default.nix
  makePkg = {
    lang,
    generate ? false,
    location ? null,
  }:
    super.stdenv.mkDerivation
    {
      name = "tree-sitter-${lang}";

      src = super.lib.getAttr "tree-sitter-grammars-${lang}" inputs;

      # nativeBuildInputs = super.lib.optionals generate [ super.pkgs.nodejs super.pkgs.tree-sitter ];

      CFLAGS = ["-Isrc" "-O2"];
      CXXFLAGS = ["-Isrc" "-O2"];

      stripDebugList = ["parser"];

      configurePhase =
        super.lib.optionalString generate ''
          tree-sitter generate
        ''
        + super.lib.optionalString (location != null) ''
          cd ${location}
        '';

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
in {
  tree-sitter-grammars =
    super.tree-sitter-grammars
    // super.lib.listToAttrs (map
      (l: {
        name = "tree-sitter-${l.lang}";
        value = makePkg l;
      })
      (super.lib.attrValues languages));
}
