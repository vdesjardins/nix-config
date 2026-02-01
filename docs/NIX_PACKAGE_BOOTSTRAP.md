# Bootstrap Nix Package Guide

**Purpose:** Clear, actionable steps to create and build a Nix package from
GitHub source.

## Prerequisites

Before starting, gather the following information:

- **GitHub repository URL** (e.g., <https://github.com/owner/repo>)
- **Package name** (used in flake outputs and `packages/{name}/package.nix`)
- **Package version** (from upstream package.json or release)
- **Build system** (NPM, Python, Rust, etc. - determines builder function)
- **Binary name** (entry point, e.g., `tmux-mcp`, `context7-mcp`)
- **License** (MIT, Apache-2.0, etc.)

## Step-by-Step Package Creation

### 1. CHOOSE BUILD SYSTEM

Determine the appropriate Nix builder:

- **NPM packages:** Use `buildNpmPackage` (Node.js/JavaScript)
- **Python packages:** Use `buildPythonPackage`
- **Rust packages:** Use `rustPlatform.buildRustPackage`
- **Go packages:** Use `buildGoModule`
- **Custom builders:** Check nixpkgs documentation

### 2. CREATE PACKAGE FILE

**File:** `packages/{name}/package.nix`

**Template for NPM package:**

```nix
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "{name}";
  version = "{version}";

  src = fetchFromGitHub {
    owner = "{github-owner}";
    repo = "{repo-name}";
    rev = "{commit-sha}";  # Pin to specific commit or tag
    hash = lib.fakeHash;  # Placeholder - will be replaced
  };

  npmDepsHash = lib.fakeHash;  # Placeholder - will be replaced

  mainProgram = "{binary-name}";

  meta = with lib; {
    description = "Package description";
    homepage = "https://github.com/{owner}/{repo}";
    license = licenses.mit;
  };
}
```

**For other build systems, reference similar packages in `packages/`
directory.**

### 3. COMPUTE HASHES

Hashes ensure package integrity and reproducibility. Follow this process:

**Initial Setup:**

- Use `lib.fakeHash` as placeholder for both hash fields
- Stage the file: `git add packages/{name}/package.nix`

**Hash Computation Workflow:**

1. Run: `nix build '.#{name}'`
2. Build will fail with error showing expected hash
3. Copy the `sha256-...` value from error message
4. Replace corresponding `lib.fakeHash` with the value
5. Save and repeat until both hashes are correct

**Example error output:**

```text
error: hash mismatch in fixed-output derivation '/nix/store/...'
  wanted: sha256-rZhVjuWRlVSjLthgSKbfuPpQQKP9YC2Pjun/6JQYUo0=
  got:    sha256-1yH4E/+HvhvKHX2Lbwqt8yVzRfLTmEuMy9xQ8w+TNCA=
```

Copy the "wanted" hash into your file.

**Order matters:**

- First error: `hash` (source download from GitHub)
- Second error: `npmDepsHash` (npm dependency tree)
- Build succeeds: Both hashes are correct

### 4. VERIFY BUILD SUCCESS

```bash
# Build the package
nix build '.#{name}'

# Verify binary exists
nix build '.#{name}' --print-out-paths
ls result/bin/  # Check binary is executable

# Run binary to verify functionality (optional)
result/bin/{binary-name} --help
```

### 5. LINT & FORMAT

```bash
nix develop -c prek run -a
```

This auto-formats your Nix code with `alejandra`.

### 6. VERIFY FLAKE INTEGRATION

```bash
# Validate package is discoverable
nix flake check

# Should show: packages.x86_64-linux.{name}-{version}.drv
```

## Key Patterns

### Hash Fields Explained

```nix
hash = "sha256-...";        # Source code hash (GitHub download)
npmDepsHash = "sha256-..."; # npm dependencies hash (lockfile)
```

- **Never hardcode hashes without computing them**
- Use `lib.fakeHash` initially, compute via build failures
- Different build systems have different hash field names

### mainProgram

```nix
mainProgram = "{binary-name}";  # Name of executable in bin/
```

This is the name users call from terminal. Must match actual binary in
`node_modules/.bin/` or equivalent.

### Meta Information

```nix
meta = with lib; {
  description = "Human-readable description";
  homepage = "https://github.com/...";
  license = licenses.mit;  # or other licenses
  maintainers = with maintainers; [username];  # Optional
};
```

## Package Definition Checklist

- [ ] File created: `packages/{name}/package.nix`
- [ ] Correct build system chosen (buildNpmPackage, etc.)
- [ ] GitHub owner/repo/rev specified
- [ ] Both hashes computed via `nix build` errors:
  - [ ] `hash` (source)
  - [ ] `npmDepsHash` (npm dependencies)
- [ ] `mainProgram` matches actual binary name
- [ ] `meta` section complete with description/homepage/license
- [ ] `git add packages/{name}/` staged in git
- [ ] `nix build '.#{name}'` succeeds
- [ ] `nix flake check` shows package in outputs
- [ ] Binary exists and is executable: `result/bin/{name}`

## Troubleshooting

**"hash mismatch" errors:**

- This is expected! It means Nix calculated a different hash
- Copy the "wanted" hash into your file
- Re-run `nix build` until no more hash errors
- Process is automatic once you know the workflow

**"cannot find mainProgram":**

- Binary name doesn't match actual file in `result/bin/`
- Check what was actually built: `ls result/bin/`
- Update `mainProgram` to match actual binary name

**"No such file or directory: packages/{name}":**

- Directory wasn't created or git didn't track it
- Create directory: `mkdir -p packages/{name}`
- Create file inside: `packages/{name}/package.nix`
- Stage it: `git add packages/{name}/`

**Package builds but "not found in outputs":**

- Nix flake needs to discover the package
- Ensure file is at: `packages/{name}/package.nix` (exact path)
- File must be staged in git: `git add packages/{name}/`
- **DO NOT run `nix flake update`** - this is unnecessary and can introduce
  upstream changes that complicate your work

## Next Steps

Once package builds successfully:

1. **Create Home-Manager Module** to expose configuration options
2. **Integrate into roles** to enable users to use the package
3. **Test in actual config** with `make hm/generate` or `make hm/apply`

See: `HM_MODULE_BOOTSTRAP_GUIDE.md` for module creation instructions.

## Quick Reference

**Common build systems:**

```nix
buildNpmPackage {}        # JavaScript/Node.js
buildPythonPackage {}     # Python
rustPlatform.buildRustPackage {}  # Rust
buildGoModule {}          # Go
```

**Verifying hash computation:**

```bash
nix build '.#{name}' 2>&1 | grep "wanted:"  # Get hash from error
git diff packages/{name}/package.nix  # See your changes
```

**Finding examples:**

```bash
# Look at similar packages in codebase
ls packages/
cat packages/context7/package.nix  # Reference implementation
```
