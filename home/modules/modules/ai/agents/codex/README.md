# Codex CLI

Enabled only for `vince@v` in `home/users/vince-v.nix`, using `codex` from the
pinned `llm-agents` input. The executable is `codex`.

## Configuration ownership

The agent module installs Codex and renders `~/.codex/nix-config.toml`. Each MCP
module contributes its native definition to `modules.ai.agents.codex.mcpServers`
inside its own enable guard. Each skill or skill bundle installs its own source
under `~/.agents/skills/` only when Codex is enabled. There is no dependency on
another agent's settings or skill directories.

- Local MCP definitions use `command` and `args`; remote servers use `url`.
- Existing opt-in MCP defaults are preserved with `enabled = false`. Memory
  Service, grep-app, and sequential-thinking are enabled for the current user.
- Credential variables use Codex's `env_vars` allowlist to forward the launching
  environment, without placing secrets into generated TOML.
- Skill sources link directly to Nix store paths. Nested upstream layouts are
  flattened so `SKILL.md` is at each skill root.
- Disabling an owning module removes its contributions on the next activation.

`nix-config.toml` is the read-only Nix source, not a native Codex include file.
Activation merges it into a regular, private, writable `~/.codex/config.toml`,
allowing Codex to persist project trust and other runtime settings. Unmanaged
keys, comments, and manually added servers are preserved. A private
`~/.codex/nix-managed.json` manifest tracks owned keys so disabling a module
removes stale Nix-managed settings on the next activation. Nix values win for
keys it owns; configure those through `modules.ai.agents.codex.settings` and
the owning modules rather than interactive commands.

Migration atomically replaces the old store symlink without modifying its
target. Invalid existing TOML aborts activation without replacing the file.
Authentication remains writable and unmanaged; run `codex login` after applying
Home Manager. No approval bypass or sandbox relaxation is configured.

Use `codex mcp list` and the interactive `/skills` view to inspect integration.
Authenticated model requests and live MCP handshakes require separate runtime
testing. The `.agents/skills` location is a shared discovery convention, so other
agents supporting that convention may also discover these skills.

References:

- <https://developers.openai.com/codex/mcp>
- <https://developers.openai.com/codex/skills>
