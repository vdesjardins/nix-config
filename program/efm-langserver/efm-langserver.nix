{ pkgs, buildGoModule, fetchFromGitHub, ... }:
buildGoModule rec {
  name = "efm-langserver";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "5f127fe1ef92eb65dbd3110cdd983ccd49b70e37";
    sha256 = "1aba675bir6i4wrwy703fqhm1psxpvsimqmaprkgm76f1vywrrx7";
  };

  doCheck = false;

  vendorSha256 = "1whifjmdl72kkcb22h9b1zadsrc80prrjiyvyba2n5vb4kavximm";
}
