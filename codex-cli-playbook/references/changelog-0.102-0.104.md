# Codex CLI changelog notes (0.102.0 → 0.104.0)

Last reviewed: 2026-02-18  
Source: https://developers.openai.com/codex/changelog

## Why this matters for operators

If you upgraded from `0.101.0` to `0.104.0`, the highest practical impact is:
1. better permissions + approval UX,
2. more reliable thread/app-server state signaling,
3. safer model downgrade detection,
4. better attachment/resume stability.

---

## 0.102.0 (largest behavior change in this range)

### New features
- Unified permissions flow with clearer permission history in TUI.
- Added slash command path for granting sandbox read access when blocked by directory permissions.
- Structured network approval prompts with richer host/protocol context.
- Expanded app-server fuzzy file search with explicit session-complete signaling.
- Added configurable multi-agent roles / naming surface.
- Added model reroute notification support.

### Fixes
- Remote image attachments persist correctly across resume/backtrack/history replay.
- Thread resume behavior improved (rejoin active in-memory threads; tighter invalid resume handling).
- Multiple js_repl stability fixes (reset hangs, in-flight tool races, view_image panic path).
- model/list returns fuller model data + visibility metadata.

### Operational takeaway
- If your workflow depends on resume + attachments + app-server events, `0.102.0` is a major reliability jump over `0.101.0`.

---

## 0.103.0

### New features
- App listing responses include richer fields (`app_metadata`, branding, labels).
- Commit co-author attribution moved to Codex-managed `prepare-commit-msg` hook with `command_attribution` override options.

### Fixes / chores with operator impact
- Removed `remote_models` feature flag fallback behavior to improve model metadata reliability.

### Operational takeaway
- Better app cards and fewer model-list surprises.
- If commit attribution behavior changed, check `command_attribution` config expectations.

---

## 0.104.0 (current target)

### New features
- Added `WS_PROXY` / `WSS_PROXY` env support (including lowercase variants) for websocket proxying.
- App-server emits thread archive/unarchive notifications (no polling needed to detect these state changes).
- Protocol/core now uses distinct approval IDs for command approvals (supports multiple approvals in one shell flow).

### Fixes
- Ctrl+C / Ctrl+D cleanly exits cwd-change prompt during resume/fork flows.
- Reduced false-positive safety-check downgrade behavior by relying on header/top-level events.

### Operational takeaway
- Proxy environments get easier websocket routing.
- Approval traceability is better in complex command execution flows.
- Thread state sync in clients can be event-driven.

---

## Upgrade verification checklist (0.101.0 → 0.104.0)

Run these after upgrade:

1. **Version check**
```bash
codex --version
```

2. **Resume / fork prompt behavior**
- Start a resume/fork flow and verify Ctrl+C exits cleanly.

3. **Attachment replay sanity**
- Send an image attachment, then resume/backtrack, ensure attachment context remains consistent.

4. **Thread state events (if app-server integration exists)**
- Archive/unarchive a thread and confirm client receives event without polling.

5. **Approval traceability**
- Trigger a command flow with multiple approvals and confirm IDs remain distinct in logs/UI.

6. **Proxy path (if behind proxy)**
- Set `WS_PROXY`/`WSS_PROXY` and verify websocket-based operations are healthy.

---

## Quick recommendations for this workspace

- Keep `workspace-write + on-request` as default safety baseline.
- Prefer evidence-based progress reporting (commit hash + test output) for long runs.
- If using Codex app-server events, start consuming archive/unarchive notifications to reduce polling loops.
