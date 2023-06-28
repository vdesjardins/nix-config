inputs: _self: super: {
  kubernetes-helmPlugins =
    super.kubernetes-helmPlugins
    // {
      helm-gcs = super.buildGoModule rec {
        name = "helm-gcs";

        src = inputs.helm-gcs;

        vendorSha256 = "sha256-wapS6O3OO65DrQ18MbS2ILBNpNvPqpHi1iuEMgFTVNg=";

        doCheck = false; # NOTE: Remove the install and upgrade hooks.

        postPatch = ''
          sed -i '/^hooks:/,+2 d' plugin.yaml
        '';

        postInstall = ''
          install -dm755 $out/${name}
          mv $out/bin $out/${name}/
          install -m644 -Dt $out/${name} plugin.yaml
          cp -r scripts $out/${name}/scripts
        '';
      };
    };
}
