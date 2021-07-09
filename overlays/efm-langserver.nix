inputs: self: super: {
  efm-langserver = super.pkgs.buildGoModule rec {
    name = "efm-langserver";

    src = inputs.efm-langserver;

    doCheck = false;

    vendorSha256 = "1whifjmdl72kkcb22h9b1zadsrc80prrjiyvyba2n5vb4kavximm";
  };
}
