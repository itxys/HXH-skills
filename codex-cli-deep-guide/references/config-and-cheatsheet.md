# Codex CLI 配置与命令速查

## A. 高频命令

```bash
codex --help
codex exec --help
codex login --help
codex mcp --help
codex resume --help
```

```bash
# 交互
codex
codex "fix lint and run tests"

# 非交互
codex exec "implement feature X"
codex exec --json "implement feature X"

# 会话
codex resume --last
codex fork --last
```

## B. 推荐安全组合

```bash
# 安全审阅
codex -s read-only -a untrusted

# 平衡开发（推荐）
codex -s workspace-write -a on-request

# 低摩擦自动执行
codex --full-auto
```

> `--full-auto` 等价低摩擦沙箱自动执行（本版本 help 描述为 `-a on-request + --sandbox workspace-write`）。

## C. 认证

```bash
# API key 登录
printenv OPENAI_API_KEY | codex login --with-api-key
codex login status
codex logout
```

## D. 非交互产物约束

```bash
codex exec \
  --json \
  --output-last-message codex-last.txt \
  --output-schema ./schema.json \
  "analyze repo and output structured result"
```

## E. config.toml 片段（示例）

```toml
model = "gpt-5.3-codex"
approval_policy = "on-request"
sandbox_mode = "workspace-write"
model_reasoning_effort = "medium"
model_verbosity = "medium"

[history]
persistence = "save-all"
max_bytes = 104857600

[profiles.safe_review]
approval_policy = "untrusted"
sandbox_mode = "read-only"

[profiles.fast_patch]
approval_policy = "on-request"
sandbox_mode = "workspace-write"
model_reasoning_effort = "low"

[features]
web_search = true
runtime_metrics = true
```

## F. MCP 片段示意

```toml
[mcp_servers.myserver]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/workdir"]
startup_timeout_ms = 20000
```

## G. 常见问题

- **会话掉线/SIGKILL**：先单线运行，减少超长 prompt，避免并发重任务。
- **权限冲突**：先切 `read-only` 验证，再逐步放开到 `workspace-write`。
- **工具不可用**：检查 `mcp_servers` 的 command/args/env 与启动超时。
- **Windows 不稳定**：优先在 WSL2 中运行 Codex CLI。
