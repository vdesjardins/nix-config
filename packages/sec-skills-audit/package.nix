{
  lib,
  python3,
  makeWrapper,
}:
python3.pkgs.buildPythonApplication {
  pname = "sec-skills-audit";
  version = "0.1.0";
  format = "other";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin
    cp sec-skills-audit.py $out/bin/sec-skills-audit
    chmod +x $out/bin/sec-skills-audit
  '';

  meta = with lib; {
    description = "Security auditor for OpenCode skill files";
    mainProgram = "sec-skills-audit";
    license = licenses.mit;
  };
}
