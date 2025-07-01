{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}: let
in
  buildNpmPackage {
    pname = "gemini-cli";
    version = "0.1.7-unstable-2025-06-29";

    src = fetchFromGitHub {
      owner = "google-gemini";
      repo = "gemini-cli";
      rev = "87d4fc05609aa2289575fea73372f6fab4281bcd";
      hash = "sha256-T5I46AQa6aP+fBmkxe1YZmvfT/N+Isp7iv8usJOh5jY=";
    };

    npmDepsHash = "sha256-7YsCtNEkibU8mwzxIj74K1+ahrgyItXfF9iqH/2LjCA=";

    meta = with lib; {
      description = "An open-source AI agent that brings the power of Gemini directly into your terminal. ";
      homepage = "https://github.com/google-gemini/gemini-cli";
      license = licenses.asl20;
      mainProgram = "gemini";
    };
  }
