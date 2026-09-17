{
  my-packages,
  pkgs,
  ...
}: let
  # vimPlugins.peek-nvim ships only TypeScript source — no built assets.
  # The nixpkgs cmd.patch rewrites app.lua to run `deno run app/src/main.ts` with
  # the nix deno store path. main.ts serves static files relative to
  # Deno.mainModule (app/src/), but built assets (index.html, script.bundle.js,
  # mermaid.min.js, katex.min.css, github-markdown.min.css) live in public/.
  # Prepend the packaged public assets to the server's lookup paths.
  peek-nvim = pkgs.vimPlugins.peek-nvim.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        sed -i \
          "s|for (const base of \[Deno\.mainModule, 'file:'\]) {|for (const base of [new URL('../../public/', Deno.mainModule).href, Deno.mainModule, 'file:']) {|" \
          app/src/main.ts
      '';

    postInstall =
      (old.postInstall or "")
      + ''
        cp -r ${my-packages.peek-nvim-assets}/. $out/public/
      '';
  });
in {
  programs.nixvim = {
    plugins.peek = {
      enable = true;
      package = peek-nvim;

      settings = {
        auto_load = true;
        theme = "dark";
        # webview mode requires a native FFI lib not available in nix sandbox;
        # use browser (xdg-open / system default) instead
        app = "browser";
        filetype = ["markdown"];
      };
    };

    extraPackages = [pkgs.deno];

    keymaps = [
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>PeekOpen<cr>";
        options.desc = "Peek Open (Markdown preview)";
      }
      {
        mode = "n";
        key = "<leader>mc";
        action = "<cmd>PeekClose<cr>";
        options.desc = "Peek Close (Markdown preview)";
      }
    ];
  };
}
