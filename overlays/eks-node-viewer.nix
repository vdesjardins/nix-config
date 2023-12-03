inputs: _self: super: {
  eks-node-viewer = super.buildGoModule {
    name = "eks-node-viewer";

    src = inputs.eks-node-viewer;

    vendorHash = "sha256-EJAL5jNftA/g5H6WUMBJ98EyRp7QJ1C53EKr6GRz71I=";
  };
}
