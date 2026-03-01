---
name: codex-cli-deep-guide
description: Deep practical guide for Codex CLI (install/login, interactive vs exec, sandbox/approval, MCP, session recovery, config, troubleshooting).
---

# Codex CLI Deep Guide

## Purpose
Provide copy-pastable Codex CLI commands and decision rules for stable daily use and troubleshooting.

## When to use
- Setup: install/login/first run
- Stable workflows: interactive mode + session management + sandbox/approval
- Automation/CI: `codex exec` + JSON output + schema constraints
- MCP: configuring MCP servers and diagnosing tool availability
- Troubleshooting: auth failures, session drops, sandbox conflicts

## Tools & Schema-first (required)
**Schema-first rule (mandatory):** before calling any tool, always call `listTools` first and read each tool's `inputSchema`. **Do not hardcode** tool names or arguments; derive the correct tool + params from `listTools` + `inputSchema`.

(For this skill, the primary “tools” are Codex CLI commands; still keep the same schema-first habit when interacting with tool-based runtimes.)

## Procedure
Follow this order and prefer commands over explanations.

### 1) Quickly classify the user's goal
- First-time use: install + login + first run
- Stable dev: interactive + session management + sandbox/approval
- Automation/CI: `codex exec` + structured output
- Multi-tool: MCP server config/login
- Troubleshooting: auth/session/sandbox

### 2) Standard command templates
**Basic start**
```bash
codex
codex "审查这个仓库并给出3个高价值改进"
```

**Non-interactive (automation)**
```bash
codex exec "实现 X 并运行相关测试"
codex exec --json "输出结构化执行事件"
codex exec --output-last-message result.txt "完成任务并总结"
```

**Session recovery**
```bash
codex resume --last
codex resume <SESSION_ID>
```

**Common safety params**
```bash
codex -s read-only -a untrusted
codex -s workspace-write -a on-request
codex --full-auto
```

### 3) Security / permission decision rules
Default recommendation: `workspace-write + on-request`.

Use `read-only + untrusted` when you need strict review constraints.

Only suggest `danger-full-access` / `--dangerously-bypass-approvals-and-sandbox` when the environment is isolated (container/CI sandbox) AND the user explicitly agrees.

### 4) Login & auth
Prefer ChatGPT login when available.

API key mode:
```bash
printenv OPENAI_API_KEY | codex login --with-api-key
codex login status
codex logout
```

If credential storage policy matters, configure `~/.codex/config.toml`:
- `cli_auth_credentials_store = "auto" | "keyring" | "file" | "ephemeral"`

### 5) Delivery conventions for CI
For stable pipelines, prefer:
- `codex exec`
- `--json` (observability)
- `--output-last-message` (artifact)
- `--output-schema <schema.json>` (structured result constraint)
- `--ephemeral` when you don't want local persistence

Example:
```bash
codex exec --json --ephemeral \
  --output-last-message codex-last.txt \
  "更新 changelog 并确保测试通过"
```

### 6) MCP workflow
- List: `codex mcp list`
- Add: `codex mcp add ...`
- Login: `codex mcp login <name>`
- Remove: `codex mcp remove <name>`

If tools are missing/unavailable, check server command exec, `startup_timeout_ms`, and env/headers/bearer token.

### 7) Windows notes
Official recommendation: use **WSL2** on Windows 11.
If PowerShell-native runs into sandbox/compat issues, suggest moving to WSL2.

### 8) Troubleshooting order
1. `codex --version`, `codex login status`
2. Minimal command: `codex exec "say ok"`
3. Check model/provider config
4. Tighten/loosen sandbox/approval to localize the issue
5. Logs: `~/.codex/log/codex-tui.log`
6. If sessions drop: reduce prompt size, reduce concurrency

## Examples
- User: “我要在 CI 里跑稳定的 codex 自动化”
  - Suggest: `codex exec --json --ephemeral --output-last-message ...` + optional `--output-schema`
- User: “codex mcp 工具列表为空”
  - Suggest: `codex mcp list` → verify server command/env/timeout

## Safety
- Do not recommend bypassing approvals/sandbox unless the user explicitly confirms and the environment is isolated.
- Prefer least-privilege defaults.

## Changelog
- v1: Standardized SKILL.md template + schema-first rule section.
