{
  python314Packages,
  fetchFromGitHub,
  lib,
}:
python314Packages.buildPythonApplication {
  pname = "mcp-memory-service";
  version = "10.61.0";

  src = fetchFromGitHub {
    owner = "doobidoo";
    repo = "mcp-memory-service";
    rev = "v10.61.0";
    hash = "sha256-8PInDF6x+L95tCfyRk4va1VlDUQ4ZHnU8LvCp5SIqhA=";
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
    aiosqlite
    fastapi
    uvicorn
    python-multipart
    sse-starlette
    aiofiles
    psutil
    zeroconf
    pypdf
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
