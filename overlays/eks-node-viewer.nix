inputs: _self: super: {
  eks-node-viewer = super.buildGoModule {
    name = "eks-node-viewer";

    src = inputs.eks-node-viewer;

    vendorHash = "sha256-PJ6TakF2yN8eB/SV5Dx164lDZDi4Hr4N2ZW8dzz8jcg=";
  };
}
