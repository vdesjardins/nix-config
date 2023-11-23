inputs: _self: super: {
  kubectl-hns = super.buildGoModule {
    name = "kubectl-hns";

    src = inputs.kubectl-hns;

    subPackages = [
      "cmd/kubectl"
    ];

    nativeBuildInputs = with super.pkgs; [installShellFiles];

    postInstall = ''
      mv $out/bin/kubectl $out/bin/kubectl-hns
      installShellCompletion --cmd kubectl-hns \
        --bash <($out/bin/kubectl-hns completion bash) \
        --zsh <($out/bin/kubectl-hns completion zsh) \
        --fish <($out/bin/kubectl-hns completion fish)
    '';

    vendorHash = null;
  };
}
