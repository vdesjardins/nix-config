inputs: _self: super: {
  kubectl-who-can = super.buildGoModule {
    name = "kubectl-who-can";

    src = inputs.kubectl-who-can;

    doCheck = false;

    vendorSha256 = "sha256-KWLuS29aI3XqqyJAY9DVX+ldFU53vEumpBKUwinhYGQ=";
  };
}
