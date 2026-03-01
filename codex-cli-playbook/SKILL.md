---
name: codex-cli-playbook
description: Practical guide for OpenAI Codex CLI usage on Windows/macOS/Linux. Use when the user asks how to install, authenticate, run, configure, sandbox/approval settings, MCP integration, scripting (`codex exec`), resume/review workflows, or troubleshooting Codex based on official docs.
---

# Codex CLI Playbook

Provide short, command-first guidance for Codex CLI.

## Default response structure

1. Goal fit (1 line)
2. Minimal command block
3. Expected success signal
4. One fallback

## Install and upgrade

```bash
npm i -g @openai/codex
codex --version

# upgrade
npm i -g @openai/codex@latest
```

## Start modes

### Interactive (default)
```bash
codex
```

### One-shot
```bash
codex exec "<task>"
```

### Resume thread
```bash
codex resume --last
codex resume --all
codex resume <thread-id>

# non-interactive resume
codex exec resume --last "<follow-up task>"
```

## Auth guidance

Codex supports:
- ChatGPT sign-in (subscription access)
- API key sign-in (usage-based)

When asked about cloud tasks: Codex cloud requires ChatGPT sign-in.

Security-critical reminders:
- cached auth may be in `~/.codex/auth.json` or OS keyring
- treat `auth.json` as secret
- for remote/headless envs, prefer device auth when available:
```bash
codex login --device-auth
```

## Config layering (important)

Precedence (high -> low):
1. CLI flags / `--config`
2. profile values
3. project `.codex/config.toml` (trusted projects)
4. user `~/.codex/config.toml`
5. system config
6. built-in defaults

## High-value config snippets

### Model + style
```toml
model = "gpt-5.3-codex"
model_reasoning_effort = "high"
personality = "pragmatic"
```

### Approval + sandbox
```toml
approval_policy = "on-request" # untrusted|on-failure|on-request|never
sandbox_mode = "workspace-write" # read-only|workspace-write|danger-full-access

[sandbox_workspace_write]
network_access = false
```

### Web search
```toml
web_search = "cached" # cached|live|disabled
```

### MCP server
```toml
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]
```

## Security presets (CLI)

```bash
# safe read-only
codex --sandbox read-only --ask-for-approval on-request

# workspace auto mode
codex --sandbox workspace-write --ask-for-approval on-request

# maximum autonomy (high risk)
codex --dangerously-bypass-approvals-and-sandbox
# alias often seen: --yolo
```

## Review workflow

Use `/review` in interactive CLI for local review presets.

When user wants automated checks before commit:
1. run review
2. patch
3. run targeted tests
4. summarize diffs and risks

## Windows guidance

Official docs indicate Windows native support is improving, but WSL is generally recommended for best compatibility/perf.

Quick path:
```powershell
wsl --install
wsl
# inside WSL
npm i -g @openai/codex
codex
```

Keep repos under Linux home (`~/code/...`) rather than `/mnt/c/...` for better I/O.

## Troubleshooting

1. `codex` not found
- verify install path and shell PATH
- check `codex --version`

2. login issues
- re-login
- verify credential store mode (`cli_auth_credentials_store`)

3. timeout / network
- test DNS + TCP + HTTPS separately

4. MCP failing
- disable servers one by one
- check startup timeout/tool timeout

## Real-world delivery pattern (OpenSpec + Codex)

Use this pattern when user wants fast, verifiable implementation (not just guidance):

1. Lock scope in one sentence (e.g., "UI-only, no backend/IPC changes").
2. Create OpenSpec change (`proposal/design/spec/tasks`) before coding.
3. Run Codex for implementation in small slices; keep at most stable parallelism for host.
4. Report progress only with evidence:
   - active session/log
   - new commit hash
   - test/build output
   - preview URL/screenshot for UI tasks
5. If evidence missing, freeze percentage; do not inflate progress.
6. For browser preview bugs, always check cache/SW interference before deeper refactor.

For concrete field lessons from Tuanbot Web IM pilot and recent reliability incidents (continuous execution, context preflight, screenshot validity), read:
- `references/openspec-codex-field-lessons.md`

For running Codex continuously (event-driven runs + watchdog, low-token main session), read:
- `references/continuous-mode-watchdog.md`

## What's New in 0.106.0 (2026-02-26)

### 对我们最有用的新功能

1. **`--full-auto` 快捷模式**
   ```bash
   codex --full-auto "task description"
   ```
   等价于 `-a on-request --sandbox workspace-write`，一个 flag 搞定自动执行，不用记两个参数。

2. **`--search` 启用实时搜索**
   ```bash
   codex --search "查找最新的 React 19 API 变化并更新代码"
   ```
   模型可以调用 web_search 工具，适合需要查文档/API 的开发任务。

3. **`--add-dir` 多目录写权限**
   ```bash
   codex --add-dir D:\shared\libs "修改主项目同时更新共享库"
   ```
   sandbox 模式下可以额外授权写其他目录，不用 danger-full-access。

4. **`codex fork` 分叉会话**
   ```bash
   codex fork --last
   ```
   从上一个会话的某个点分叉出新会话，适合"试另一种方案"。

5. **`codex review` 代码审查**
   ```bash
   codex review
   ```
   非交互式代码审查，可用于 CI/PR。

6. **`codex cloud` 云任务（实验性）**
   ```bash
   codex cloud
   ```
   浏览 Codex Cloud 任务并 apply 到本地。

7. **智能记忆管理**
   - diff-based forgetting：自动遗忘过时记忆
   - usage-aware selection：按使用频率选择记忆
   - 长会话更稳定，不容易"忘事"

8. **多 Agent 工作流增强**
   - `spawn_agents_on_csv`：从 CSV 批量派发子 agent
   - 子 agent 支持昵称、进度/ETA 显示
   - 子 agent 的 approval 弹窗更清晰

9. **模型支持：5.3-codex 可见**
   ```toml
   model = "5.3-codex"
   ```

10. **`request_user_input` 在 Default 模式可用**
    不再只限 Plan 模式，Default 协作模式下也能主动问用户。

### Bug Fixes（影响我们的）
- WebSocket 超时自动重试 + 优先 v2 协议（连接更稳）
- 子 agent Ctrl-C 处理修复
- 输入上限 ~1M 字符（防止大文件粘贴卡死）
- zsh sandbox 绕过修复（安全性提升）

### 推荐配置更新
```toml
# ~/.codex/config.toml
model = "gpt-5.2"           # 或 "5.3-codex"
approval_policy = "on-request"
sandbox_mode = "workspace-write"
web_search = "cached"

[features]
voice_transcription = false  # 语音输入（实验性，按住空格录音）
```

## References

- `references/official-sources.md`
- `references/deep-summary.md`
- `references/windows-quickstart.md`
- `references/changelog-0.102-0.104.md` (upgrade notes from 0.101.0 path)
- `references/openspec-codex-field-lessons.md`
- `references/auto-continuation-control-template.md`
