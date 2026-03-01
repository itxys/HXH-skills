# OpenSpec + Codex Field Lessons (Tuanbot Web IM Pilot)

## Scope control
- Freeze blast radius early: "UI-only" if user asks for test-page delivery.
- Avoid touching backend/runtime when acceptance target is visual/interaction demo.

## Execution cadence
- Use OpenSpec artifacts first:
  - proposal.md
  - design.md
  - specs/.../spec.md
  - tasks.md
- Then ship thin implementation slices with Codex.

## Evidence-first progress policy
Only increase progress % when at least one new hard artifact exists:
1) new commit hash, and/or
2) new test/build output, and/or
3) running preview URL with screenshot.

If none exists, keep percentage frozen and state why.

## Mobile/desktop UI pitfalls found
1. Mobile input bar missing:
   - root cause: viewport height + safe-area handling
   - fix: use `100dvh` and `env(safe-area-inset-bottom)` padding
2. Desktop washed-out style:
   - likely SW/cache interference
   - fix: disable/unregister Service Worker for preview route (`?webIm=1`) and hard refresh

## Failure log: false progress incident (must avoid)
### What went wrong
- Progress updates kept repeating while no new coding evidence was produced.
- Assistant over-indexed on reminder cadence and under-indexed on implementation throughput.
- Planning artifacts were done, but coding proof (commit/test/url) lagged too long.

### Why it happened
1. Process drift: reminder loop became the dominant output.
2. Evidence gap: no hard gate enforced before increasing or repeating optimistic status.
3. Over-conservative execution: too much pre-implementation caution for a UI-only target.
4. Session instability context (SIGKILL risk) slowed parallel attempts and created hesitation.

### Mandatory guardrails
- Never report "new progress" without new artifact evidence.
- If no new evidence, explicitly label as "frozen" and explain the exact missing artifact.
- Prioritize deliverables over status chatter: screenshot + URL + commit beat narrative.
- On trust-sensitive projects, set and follow hard gates from the start.

## Practical PM/Tech-Director pattern
- Keep status updates short and verifiable.
- Stop periodic reminders immediately when user asks.
- Resume only on user instruction.
- Prefer "deliver screenshot + URL" over repeated text status for UI work.
- Use English when collaborating with Codex under the OpenSpec + Codex workflow (prompts, tasks, and implementation instructions), unless user explicitly requests another language.
- Keep user-facing updates in the user's preferred language (for this project: Chinese), including hook-triggered reminder/summary text.

## Delivery routing (project-specific: Tuanbot)
- **All milestone/task reports must be posted to Telegram group `-5141791353`.**
- When sending via OpenClaw, use the message tool with:
  - `channel=telegram`
  - `target=telegram:-5141791353`
- If work is running in an isolated sub-session, **draft** the group update text there, then have the main session send it (avoid accidental wrong-recipient delivery).

## Hook-driven closed loop (low-token orchestration)
Use event-driven hooks instead of frequent polling for long/complex Codex runs.

### Fallback patrol must be proactive (not passive)
- Patrol is not only for status reporting; it must actively keep delivery moving when hook events are missing.
- If there is no new hook event and no verifiable progress evidence (commit/test/output), proactively re-launch or continue the next migration slice.
- Keep evidence-first reporting unchanged: only claim progress with hard artifacts.
- Keep a permanent low-frequency fallback even when hooks are stable (to cover SIGKILL / dropped events).
- Current preferred ladder for this project: 3 -> 6 -> 10 minutes, capped at 10 minutes.

### Reliability hierarchy for Codex+OpenSpec orchestration
- Treat OpenClaw session-completion callback as the primary delivery channel (event-driven, low latency).
- Treat Codex notify hook as an enhancement channel (especially useful for terminal/abnormal-exit wakeups), not the sole source of truth.
- Keep fallback patrol as a safety fuse only (low frequency), not as the default control loop.
- Recommended stack: event-driven primary + hook enhancement + low-frequency fallback.

### Pattern
1. Codex hook fires on turn-end / terminal events.
2. Hook writes `latest.json` atomically (tmp file -> rename).
3. Hook emits OpenClaw wake event (`openclaw system event --mode now ...`).
4. OpenClaw reads `latest.json` and sends concise chat update.

### Terminal reliability
- Treat `stop` and `sessionEnd` as terminal event triggers.
- Add run-level de-dup (e.g., `runId + notified`) to avoid duplicate notifications.

### `latest.json` minimum schema
```json
{
  "version": 1,
  "at": 1771085287341,
  "runId": "run-001",
  "eventType": "sessionEnd",
  "status": "completed",
  "summary": "...",
  "command": "...",
  "terminal": true,
  "notified": true,
  "source": "codex-hook"
}
```

### Why this saves tokens
- No 5-minute status chatter loop.
- Updates occur only on meaningful events.
- Chat replies can be generated from compact structured payloads.

## Suggested completion checklist for UI pilot
- [ ] Commit hash recorded
- [ ] Preview URL reachable on LAN and localhost
- [ ] Desktop screenshot
- [ ] Mobile screenshot (real device if possible)
- [ ] Known issues + next delta explicitly listed

## Continuous execution continuity lessons (important)
1. After each milestone report, immediately spawn the next queued task in the same turn when user requested “continuous mode”.
2. Do not stop at a “checkpoint complete” message; checkpoint != workflow completion.
3. If no active subagent session exists after a milestone, treat it as a continuity failure and relaunch the next task proactively.
4. In Windows PowerShell, avoid `&&`; use `;` or `if ($LASTEXITCODE -eq 0) { ... }` to prevent parser breaks from interrupting automated chains.
5. Every user-facing milestone update must end with exactly the next two planned tasks; if none remain, explicitly state all tasks are completed.

## Recent reliability incidents and hard fixes (must follow)

### 1) "Continuous execution" was falsely assumed
- Root cause: `sessions_spawn` is one-shot by design; prompt-level "continue until done" does not create a persistent supervisor.
- Fix pattern:
  1. Add external watchdog (cron or explicit patrol loop) with hard done criteria.
  2. Treat empty output / partial summary as non-complete and relaunch immediately.
  3. Report liveness truthfully from `sessions_list`/scheduler state (running vs stopped), never by intention.

### 2) Repeated testing in wrong context (identity/config not actually bound)
- Root cause: tests were repeatedly executed in a context that did not carry effective user identity/config sync, causing misleading "model not configured" loops.
- Fix pattern (preflight gate before any E2E claim):
  1. Verify effective identity context exists (user/session binding).
  2. Verify capability model list is injected into current client session.
  3. Verify backend config is actually hit by this session (not just present on server).
- Rule: if preflight fails, stop E2E claims and fix context first.

### 3) Invalid screenshot was reported as acceptance evidence
- Root cause: screenshot quality gate was missing/weak (e.g., blank/irrelevant frame).
- Fix pattern:
  1. Define strict screenshot acceptance gate before capture.
  2. Reject evidence if required visual anchors are absent.
  3. For chat-image acceptance, require same-panel visibility of:
     - user request text
     - generated-image reply (URL or rendered media)
- Rule: if not meeting gate, explicitly mark as invalid and recapture; do not "soft pass".

## Proven auto-continuation pattern (validated in this wave)
1. Close each milestone reply with a concrete “next two tasks” plan, then immediately spawn the next run and include `runId` as proof.
2. Use a strict handoff rule: `phase N done` -> `phase N+1 spawned in same turn` (no wait-for-confirm unless user explicitly asks to pause).
3. Keep each phase scoped with deterministic gates + `tsc --noEmit` + `build`; only claim phase completion after all required checks pass.
4. Keep unrelated dirty files untouched and mention boundary compliance in every milestone report.
5. If a blocker appears, log root cause + workaround in the same milestone and continue the chain without dropping continuity.
6. Finish with completion scan: if no executable items remain, explicitly output “全部任务已完成” and stop auto-spawn.

## New Codex + OpenSpec lessons (2026-02-23, MeetingRoom/Web-IM wave)

### A) “Implemented” != “User-effective”
- Code/test pass is insufficient when deployment path is hybrid (non-git server + static overwrite + long-lived worker).
- Mandatory closing proof for user-facing fixes:
  1. code commit hash
  2. deployed asset hash/timestamp on target host
  3. live-path user reproduction cleared
- If any of the three is missing, report as “partially done”, never “done”.

### B) Server topology preflight before promising delivery
- Preflight must include:
  1. target dir is/is-not git repo
  2. static root mapping (`webImStaticDir`) and reverse-proxy routes
  3. long-lived consumers (worker) are supervised
- This avoids false assumptions like “already deployed by git pull”.

### C) Orchestration lesson: heartbeats are observability, not progress
- 3-minute heartbeat helps liveness visibility, but does not create forward progress by itself.
- Real progress still requires explicit run ownership + completion criteria + restart policy.
- Stop heartbeat immediately after completion to reduce noise/cost.

### D) UX-first iteration policy for AI meeting products
- For collaboration surfaces, prioritize in this order:
  1. interruptibility (`Stop Current/Stop All`)
  2. context transparency (preview what each role receives)
  3. perceived latency (stream status + typewriter answer)
- Hide engineering-grade system payloads by default; keep debug mode for diagnostics.

### E) Regression guard for runtime routing and global hooks
- Add targeted gate tests whenever routing/hook behavior is changed:
  - MeetingRoom managed/direct routing gate
  - global input hook default behavior gate
- Rationale: these regressions are silent in unit-level checks but high-impact in user perception.

## New field lessons (2026-02-24, WebIM modelName structured sync wave)

### 1) Prefer structured fields over overloading `summary`
- Problem: using `summary` as a “bag of everything” forces WebIM to parse strings and becomes brittle.
- Better: add first-class optional fields (`modelName`, `modelConfigId`) in the `roles/report` payload, persist on server, and let WebIM display from server response.
- Keep backward-compat by parsing old `summary` only as a fallback.

### 2) Windows shell reliability: avoid PowerShell heredoc + quoting traps
- PowerShell does not support bash-style `<<EOF` heredocs; it will break command parsing.
- For long Codex prompts on Windows:
  - write prompt to a file, then `cmd /c "codex exec - < prompt.txt"`
  - or feed stdin in a way that avoids quoting/escape issues.

### 3) Tooling portability: do not assume `rg` exists
- Some Windows envs don’t have ripgrep (`rg`) installed/available in PATH.
- Use `git grep` (preferred) or `findstr` for repo search in automation.

### 4) Always pin/verify workdir before searching/editing
- A frequent failure mode is running searches in the wrong directory and concluding files are missing.
- Preflight: `git rev-parse --show-toplevel` + check key file existence before `grep/search`.

### 5) Keep main session token-light; put multi-step dev in isolated runs
- For long chains (multi-file edits + gates + smoke): run in an isolated sub-session driving Codex CLI.
- Main session should only receive: conclusion + evidence (commit + commands + PASS/FAIL) + risk + next.
