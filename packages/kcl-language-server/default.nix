{
  fetchFromGitHub,
  lib,
  pkg-config,
  protobuf,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "kcl-language-server";
  version = "unstable-main";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "main";
    hash = "sha256-0zsG7caJL3eA+97AcRsde8A2JhF51mUT6ZLD6OrY1MI=";
  };

  # Set the sourceRoot to the repository root so Cargo.lock is found
  sourceRoot = "${src.name}";

  # Use the Cargo.lock from our package directory (at repo root)
  postUnpack = ''
    cp "${./Cargo.lock}" "$sourceRoot/Cargo.lock"
  '';

  # Now we can use the workspace Cargo.lock, but we only build the LSP tool
  buildAndTestSubdir = "crates/tools/src/LSP";

  cargoHash = "sha256-7pA0aQ2Kjnxg+8N477bCE9emzU++LVLHLVVbMEKsqWQ=";

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  doCheck = false;

  meta = {
    description = "KCL Language Server - built from main branch with vendored Cargo.lock";
    homepage = "https://www.kcl-lang.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "kcl-language-server";
  };
}
