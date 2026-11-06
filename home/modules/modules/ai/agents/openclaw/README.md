# Tailscale access for AI agents

OpenClaw uses a named Tailscale Service:
`https://openclaw.cerberus-pollux.ts.net/`. Its gateway binds only to loopback
on port 18789. Native managed Serve is disabled; no public Funnel is enabled.

Token authentication and browser device pairing remain enabled. Set
`gateway.auth.allowTailscale = false`, trust only the local proxy addresses
`127.0.0.1` and `::1` in `gateway.trustedProxies`, and add the named HTTPS
origin to `gateway.controlUi.allowedOrigins`. Named Services do not support
OpenClaw's native Tailscale identity authentication. Tailnet access rules
provide an additional network access check, not a replacement for the token.

The Tailscale daemon must be logged in, MagicDNS and HTTPS enabled, and the
intended clients allowed by tailnet policy. Grant the user operator access
with `sudo tailscale set --operator="$USER"` (this grants broader Tailscale
administration rights). Configure providers with `openclaw onboard`, without
installing a second daemon. Home Manager owns `openclaw-gateway.service`.

OpenClaw's mutable config should include its device HTTPS origin in
`gateway.controlUi.allowedOrigins`. Keep secrets outside the Nix store;
`modules.ai.agents.openclaw.gateway.environmentFile` can reference a private
mode-0600 file containing `OPENCLAW_GATEWAY_TOKEN` and provider keys.

## OpenCode named Service

OpenCode separately uses `https://opencode.cerberus-pollux.ts.net/` on port 443,
backed by loopback port 4096. It retains its existing server-password auth.
The named Service has a separate virtual IP and does not conflict with
OpenClaw's device port 443.

In the Tailscale console:

1. Declare an owned host tag (for example `tag:ai-host`) in Access controls.
2. Tag host `v`. Review SSH and other access rules first: tagging changes its
   device identity from user-owned to tagged.
3. Under Services, define `opencode` and `openclaw` with TCP 443 endpoints.
4. Grant intended clients access to `svc:opencode` and `svc:openclaw` on `tcp:443`.
5. After applying Home Manager, approve `v` as the host for both Services.

The user unit `opencode-tailscale` manages the dedicated `svc:opencode` route.
Stopping it clears only that named Service. Never run `tailscale serve reset`
as part of migration: it can remove unrelated routes.

The user unit `openclaw-tailscale` similarly manages the dedicated
`svc:openclaw` route. The previous native foreground device route disappears
when the old gateway stops. Do not delete the named Service during migration.

Verify with `journalctl --user -u openclaw-gateway`,
`systemctl --user status opencode-tailscale`, and
`tailscale serve status --json`.
