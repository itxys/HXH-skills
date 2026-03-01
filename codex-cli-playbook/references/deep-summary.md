# Codex docs deep summary (actionable)

## 1) Core modes
- `codex`: interactive TUI session.
- `codex exec "..."`: non-interactive automation.
- Resume support for both interactive and exec flows.

## 2) Auth model
- ChatGPT sign-in and API-key sign-in are both supported in CLI/IDE.
- Codex cloud requires ChatGPT sign-in.
- Credential storage can be file/keyring/auto.

## 3) Security control model
Two orthogonal controls:
- sandbox_mode: technical capability boundaries.
- approval_policy: when user confirmation is required.

Common defaults emphasize workspace-limited edits and approval for risky actions.

## 4) Config system
- User config: `~/.codex/config.toml`
- Project override: `.codex/config.toml` (trusted project only)
- Strong precedence ordering; CLI flags/overrides win.

Useful one-off overrides:
```bash
codex --config model='"gpt-5.3-codex"'
codex --config sandbox_workspace_write.network_access=true
```

## 5) MCP
- Supports stdio and HTTP MCP servers.
- Supports bearer token and OAuth flows.
- Tools can be allowlisted/denylisted per server.

## 6) Windows
- Native Windows path exists, but docs recommend WSL for best reliability/performance.
- Keep repos inside Linux home path for faster I/O.

## 7) Web search
- `web_search` supports `cached`, `live`, `disabled`.
- Cached mode is default in local tasks and reduces live prompt-injection exposure.

## 8) Operational advice for automation
- Use constrained prompts and small diffs.
- Require explicit output contract: changed files + tests + commit.
- Prefer targeted tests per slice; periodic broader regression.

## 9) Recent release highlights (0.102.0–0.104.0)
- Permissions/approval UX and traceability improved significantly (notably 0.102.0 and 0.104.0).
- Resume + attachment consistency improved (0.102.0 fixes around image attachment replay/resume).
- App-server thread state signaling is stronger (archive/unarchive notifications in 0.104.0).
- Proxy environments can now use `WS_PROXY`/`WSS_PROXY` for websocket routing (0.104.0).

For details and operator checklist, see:
- `references/changelog-0.102-0.104.md`
