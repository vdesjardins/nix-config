# Adding MCP Servers

Follow the [package](NIX_PACKAGE_BOOTSTRAP.md) and
[Home Manager](HM_MODULE_BOOTSTRAP.md) guides for packaging and module structure.
Prefer a packaged server from existing inputs when available; a remote server
may not need a package at all.

## Repository Wiring

- Module path: `home/modules/modules/ai/mcp/<name>/default.nix`.
- Option namespace: `modules.ai.mcp.<name>`; guard all wiring with its enable
  option and expose package/settings overrides as appropriate.
- Role: add an option under `roles.ai.tools.mcp.<name>` and assign it to
  `modules.ai.mcp.<name>` in `home/modules/roles/ai/tools.nix`.
- Modules and packages are automatically discovered. Track new files; do not
  add manual imports or update flake inputs just to register them.

Choose the intended agents explicitly and follow a matching current module:

| Consumer | Configuration path |
| --- | --- |
| Neovim | `modules.desktop.editors.nixvim.ai.mcpServers.<name>` |
| GitHub Copilot CLI | `modules.ai.agents.github-copilot-cli.settings.mcpServers.<name>` |
| Kiro | `modules.ai.agents.kiro.settings.mcpServers.<name>` |
| OpenCode | `programs.opencode.settings.mcp.<name>` |
| Pi overrides | `modules.ai.agents.pi.mcpServers.<name>` |

Pi defaults are derived from OpenCode's local/remote MCP definitions by
`home/modules/modules/ai/agents/pi/default.nix`. This includes enabled state,
argument splitting, environment interpolation, and timeout conversion. Reuse
that bridge unless Pi needs a deliberate override; do not duplicate entries.

## Transport and Defaults

- For stdio, reference installed binaries with `lib.getExe cfg.package`, passing
  arguments separately where the consumer requires it. OpenCode local commands
  are lists containing executable plus arguments.
- Remote transports and authentication differ by consumer. Verify the pinned
  version's API rather than copying one agent's configuration verbatim.
- Decide role and per-agent enable states separately. Existing OpenCode entries
  commonly use `enabled = false`, and Kiro uses `disabled = true`; preserve
  intentional defaults. Pi inherits the OpenCode enabled state by default.
- Do not embed credentials in generated JSON or Nix expressions. Use the
  consumer's supported runtime environment or authentication mechanism, keeping
  secrets outside the Nix store.

## Validation

Build any new package directly and build the affected Home Manager configuration:

```bash
nix develop -c nix build '.#<package>'
nix develop -c prek run -a
nix develop -c make hm/generate
```

Inspect generated configuration for the intended transports, commands, and
per-agent enable states without printing secrets. A successful build alone does
not test the MCP handshake: smoke-test the server with a supported client when
possible. State which clients or authentication steps remain untested. Never
apply, describe, create, rearrange, or publish VCS changes without permission.

## Examples

- [context7](../home/modules/modules/ai/mcp/context7/default.nix): local stdio
  server wired to multiple agents.
- [tmux-mcp](../home/modules/modules/ai/mcp/tmux-mcp/default.nix): custom arguments.
- [grep-app](../home/modules/modules/ai/mcp/grep-app/default.nix): remote MCP server.
