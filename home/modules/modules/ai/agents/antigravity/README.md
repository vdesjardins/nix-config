# Antigravity CLI

Enabled only for `vince@v` in `home/users/vince-v.nix`. Uses `antigravity-cli`
from the pinned `llm-agents` flake input; the executable is `agy`.

## Module ownership

Each MCP module contributes its native definition to
`modules.ai.agents.antigravity.mcpServers` inside its own enable guard.
The agent module only installs the CLI and renders those definitions into
`~/.gemini/config/mcp_config.json`. There is no dependency on OpenCode settings.
Per-agent `disabled` defaults remain unchanged; disabling the owning MCP module
removes its registrations across clients.

Each skill module links its own Nix source directly into
`~/.gemini/antigravity-cli/skills/<name>/` when Antigravity is enabled. Skill
bundles in OfficeCLI, Parallel, Hunk, and Graphify follow the same pattern.
There is no dependency on Pi's skill directory. Nested upstream skill layouts
are flattened to place `SKILL.md` at the skill root. Disabling a skill or bundle
removes its links across clients on the next Home Manager activation.

The global MCP file is shared with the Antigravity App/IDE. Make persistent
changes through Nix rather than `agy mcp add` or the interactive `/mcp` editor.
Credentials are inherited from the launching environment, never embedded in
MCP JSON. Authentication and application state remain writable and unmanaged.
Permissions are not bypassed.

Run `agy` to authenticate. Use `agy mcp list` and the interactive `/mcp` and
`/skills` views to inspect runtime integration. Config parsing can be tested in
a temporary home without authentication; live handshakes and model requests
require a separate authenticated test.

Upstream documentation:

- <https://antigravity.google/docs/features/?tab=cli#antigravity-cli-features>
- <https://antigravity.google/docs/mcp/>
- <https://antigravity.google/docs/skills/>
- <https://antigravity.google/docs/customization-discovery/>
