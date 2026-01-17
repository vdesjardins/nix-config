{
  python314Packages,
  fetchFromGitHub,
  lib,
}:
python314Packages.buildPythonApplication {
  pname = "mcp-memory-service";
  version = "9.0.4";

  src = fetchFromGitHub {
    owner = "doobidoo";
    repo = "mcp-memory-service";
    rev = "v9.0.4";
    hash = "sha256-2Qn9pb5smeP08+6uBzrGorWWYvq35kVLj5q6T4pJfHA=";
  };

  postPatch = ''
    # Remove python-semantic-release from build requirements since it's not available in nixpkgs
    sed -i 's/"hatchling", "python-semantic-release", "build"/"hatchling", "build"/g' pyproject.toml
  '';

  build-system = [
    python314Packages.hatchling
    python314Packages.build
  ];
  pyproject = true;

  dependencies = with python314Packages; [
    tokenizers
    mcp
    python-dotenv
    sqlite-vec
    build
    aiohttp
    fastapi
    uvicorn
    python-multipart
    sse-starlette
    aiofiles
    psutil
    zeroconf
    pypdf2
    chardet
    click
    httpx
    authlib
    python-jose
    sentence-transformers
    torch
    apscheduler
    onnxruntime
  ];

  doCheck = false;
  dontUsePytestCheck = true;
  dontCheckRuntimeDeps = true;

  meta = {
    description = "MCP Memory Service - Stop re-explaining your project to AI every session";
    homepage = "https://github.com/doobidoo/mcp-memory-service";
    license = lib.licenses.asl20;
    mainProgram = "memory";
  };
}
