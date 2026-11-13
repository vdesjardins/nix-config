# Adding Home Manager Modules

## Integration

- Reusable modules live under `home/modules/modules/` and are automatically
  imported. Both `<category>/<name>.nix` and `<category>/<name>/default.nix` are
  used; follow the neighboring layout. Make new files visible to the flake
  through Git staging or Jj tracking.
- Use the corresponding `modules.<category>.<name>` namespace. AI agents, tools,
  and MCP servers live under `modules.ai.agents`, `modules.ai.tools`, and
  `modules.ai.mcp`, respectively.
- Declare an enable option, defaulting to false, and guard configuration with
  `lib.mkIf cfg.enable`. Expose a package override where useful; prefer existing
  inputs or packages over duplicating upstream definitions. `my-packages` gives
  access to repository packages.
- Use `lib.getExe` or `lib.getExe'` for executable references. Verify actual CLI
  flags and upstream module options for the pinned version.
- Gate platform-specific services and packages appropriately. An enable toggle
  must not accidentally install a Linux-only package on Darwin.

## Roles and User Scope

Roles group module settings under `home/modules/roles/`. To expose a tool through
an existing role, add both its option and the corresponding module assignment.
The role's default is separate from the reusable module's opt-in enable option.

For AI tools, see `home/modules/roles/ai/tools.nix`. For a user-specific service,
set it in the appropriate `home/users/<user>-<host>.nix` rather than enabling it
through a shared role. Add required host configuration separately; Home Manager
cannot provide privileged host settings such as FUSE helpers.

## State and Secrets

Keep secrets out of Nix expressions and store-backed configuration. Use private
runtime files or existing secret-management patterns. Applications that refresh
tokens need writable state; activation must not replace it with stale secrets.
Document interactive setup and external prerequisites rather than silently
performing authentication or changing network exposure.

## Validation

```bash
nix develop -c prek run -a
nix develop -c make hm/generate
```

Inspect auto-fixes and rerun checks. Build affected host configurations when host
settings change. A service unit building successfully does not establish that
its commands, credentials, permissions, or network listeners work. Test relevant
runtime behavior where safe, and report what still requires activation or user
setup. Do not run apply targets unless requested.

## Examples

- [tokscale](../home/modules/modules/ai/tools/tokscale.nix): package option from
  an existing flake input.
- [Hex](../home/modules/modules/ai/tools/hex.nix): upstream module import and
  compositor integration.
- [Google Drive](../home/modules/modules/services/google-drive/default.nix):
  user service, writable credentials, and host prerequisites.
- For agent-specific server wiring, see the [MCP guide](MCP_BOOTSTRAP_GUIDE.md).
