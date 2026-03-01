# Runtime Routing（执行与降级）

## 路由决策核心
- 文件：`server/agent-runtime/runtimeModelRouting.mjs`
- 归一化 provider：
  - `tuanbot-managed -> platform-managed`
  - `openai-codex/codex-cli -> codex`
- 后端类型：
  - managed -> `managed`
  - codex provider -> `codex-sidecar`
  - 其他 -> `openai-compatible`

## 主执行面
- `server/agent-runtime/codexSidecarRuntime.mjs`
  - thread/start -> turn/start -> item events -> turn/completed
  - 工具调用 event：`tool.call.started/finished`
  - context/memory event：`context.policy.applied`、`memory.recall.applied`

## 降级策略
- sidecar 不可用 / session 异常：回退 local runtime
- 模型不支持 codex：回退 local runtime
- 强制 codex 模式（环境变量）下则不回退，直接错误

## 严格失败策略
- 文件：`services/agent/runtimeFailurePolicy.ts`
- 命中失败文本时应阻断“继续兜底生成计划”，避免假成功

## 执行优化建议
1. 先确认 `resolveRuntimeBackendKind` 输出再改调用链。
2. 改路由逻辑必须跑：
   - `npm run test:gate:runtime-adapter-routing`
   - `npm run test:gate:runtime-failure`
3. 改 event 结构必须跑 timeline/event-center 相关 gates。
