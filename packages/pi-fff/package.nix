{
  lib,
  autoPatchelfHook,
  buildNpmPackage,
  fetchurl,
  stdenv,
}:
buildNpmPackage (finalAttrs: {
  pname = "pi-fff";
  version = "0.11.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@ff-labs/pi-fff/-/pi-fff-${finalAttrs.version}.tgz";
    hash = "sha256-0lystSl0qMmb4ez4igulVEWUAqiFB5jMci4IsIjSHeM=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-nQldtAQAmTttDiTG4PGdoaiDZ3/lANWMqxzxHgdmXjE=";
  npmFlags = ["--omit=dev" "--legacy-peer-deps"];
  packageLock = ./package-lock.json;
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  dontNpmBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r src package.json pi-fff.schema.json node_modules $out/
    runHook postInstall
  '';

  meta = {
    description = "Pi extension: FFF-powered fuzzy file and content search";
    homepage = "https://github.com/dmtrKovalenko/fff/tree/main/packages/pi-fff";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
