# Continuous mode (Codex CLI) — event-driven + watchdog (OpenClaw)

Use this when you need Codex CLI to work continuously on long tasks without burning main-session context.

## Core idea
- **Primary (event-driven):** run long work in an **isolated** session via `sessions_spawn` that drives **Codex CLI**.
- **Fallback (watchdog):** a low-frequency cron checks for **stalled evidence** and **auto-respawns**.

This gives: low-token main session + real continuity if a run is interrupted.

---

## Files (single source of truth)
Store all continuity in workspace files (not chat history):

### `ops/codex-continuous/state.json`
Minimum schema (recommended):
```json
{
  "version": 1,
  "enabled": true,
  "paused": false,
  "activeTask": null,
  "lastEvidenceAt": null,
  "lastRun": null,
  "respawnPolicy": {
    "thresholdMinutes": 10,
    "windowMinutes": 60,
    "maxRespawns": 3
  },
  "respawnHistory": []
}
```

`activeTask` shape:
```json
{
  "name": "webim-foo",
  "task": "<the exact sessions_spawn task prompt>",
  "doneCriteria": "<human DoD>",
  "startedAt": "2026-02-24T00:00:00.000Z",
  "updatedAt": "2026-02-24T00:00:00.000Z"
}
```

### `ops/codex-continuous/latest.json`
Write on each milestone (commit/gate/deploy). Suggested schema:
```json
{
  "version": 1,
  "at": "2026-02-24T00:00:00.000Z",
  "task": "webim-foo",
  "status": "running|blocked|completed",
  "evidence": {
    "commit": "<hash or null>",
    "commands": [
      {"cmd":"npx tsc -p tsconfig.json --noEmit","result":"PASS"}
    ]
  },
  "risk": "...",
  "next": ["...","..."]
}
```

### `HANDOVER-LITE.md`
When main-session context nears full, create/update a 20-line handover and continue in a fresh isolated session.

---

## Watchdog rules (must-have)
- **Do nothing** when `activeTask` is null, `enabled=false`, or `paused=true`.
- Only intervene when **no new evidence** for `thresholdMinutes`.
- Before respawn: check if the last spawned session is still active (recent update).
- **Backoff / cap:** within `windowMinutes`, respawn at most `maxRespawns`. If exceeded, stop auto-respawn and escalate (needs human).

---

## Windows prompt feeding (Codex CLI)
Avoid PowerShell heredoc. For long prompts:
```bat
REM write prompt to file first
codex exec --dangerously-bypass-approvals-and-sandbox - < prompt.txt
```

---

## When to use OpenSpec + Codex
Use OpenSpec when the task changes protocols/contracts, needs compatibility, or will be maintained long-term.
Otherwise, prefer Codex-only for small scoped fixes.
