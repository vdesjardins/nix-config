{
  buildGoModule,
  fetchFromGitHub,
  lib,
  ...
}:
buildGoModule {
  pname = "ketall";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "corneliusweig";
    repo = "ketall";
    rev = "16390bd75095091b59142cd34f4c5ae060738556";
    sha256 = "sha256-36hJ1r6Ql40zhQSUCT5qn1uOyxcDr5jnkbFkwaidINo=";
  };

  vendorHash = "sha256-aSgVzygYtQL64rZaJACztDHfz2fzn/an733NdAovy6I=";

  meta = {
    description = "Like `kubectl get all`, but get really all resources";
    homepage = "https://github.com/corneliusweig/ketall";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; all;
  };
}
