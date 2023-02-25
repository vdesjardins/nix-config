inputs: self: super: {
  kubectl-sniff = super.buildGoModule rec {
    name = "kubectl-sniff";

    buildInputs = with super; [kubectl go gnumake wget];

    src = inputs.kubectl-sniff;

    subPackages = ["cmd"];

    vendorSha256 = "7pSpOF8UASWqRMWaomoUBA3pD8t0qWiaIcGlXEm0Yx0=";

    doCheck = false;

    postInstall = ''
      mv $out/bin/cmd $out/bin/kubectl-sniff
      ln -s ${self.static-tcpdump}/sbin/static-tcpdump $out/bin/static-tcpdump
    '';
  };
}
