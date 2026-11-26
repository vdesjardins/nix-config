# Claude Code agent integration

Enabled for `vince@v` through `modules.ai.agents.claude-code.enable`, using
Claude Code from the pinned `llm-agents` input. The existing shell-tools module
remains available for users who only want the CLI without this integration.

Each MCP module contributes a native definition to
`modules.ai.agents.claude-code.mcpServers` under its own enable guard. Home
Manager packages these into its generated personal plugin under
`~/.claude/skills/claude-code-home-manager/`; no other agent's config is read.
The plugin manifest name is `hm`, so tool names can include that namespace.

Opt-in MCP defaults remain disabled using Home Manager's
`disabledMcpjsonServers` settings. The base list is always declared so it is
recomputed when servers are removed or enabled. Memory Service, grep-app,
and sequential-thinking are enabled for this user. MCP subprocesses inherit
credentials from the launching environment; secrets never enter generated JSON.

Each skill and bundle module installs its own direct Nix source under
`~/.claude/skills/` when this integration is enabled. Nested upstream skill
layouts are flattened. Disabling an owning feature removes its registrations
on the next activation.

`programs.claude-code.mutableSettings` is enabled, allowing Home Manager to
merge static settings into writable `~/.claude/settings.json` while preserving
undeclared runtime preferences. Authentication and `~/.claude.json` remain
writable and unmanaged. No sandbox relaxation or approval bypass is configured.

After activation, run `claude` to authenticate and use `/mcp` and `/skills` to
inspect integration. A successful build or CLI version check does not establish
live MCP connectivity or authenticated model access.

References:

- <https://code.claude.com/docs/en/mcp>
- <https://code.claude.com/docs/en/skills>
- Pinned Home Manager `modules/programs/claude-code/` implementation.
