# Tuanbot Architecture Map（2026-02-15 Snapshot）

## 1) 总体分层
- **Desktop Client（Electron + React）**
  - 主流程入口：`electron.mjs`、`App.tsx`
  - 前端运行时接入：`services/agent/*`、`services/runtimes/*`
- **Agent Runtime（本地 + sidecar）**
  - 主体：`server/agent-runtime/index.mjs`
  - Sidecar：`server/agent-runtime/codexSidecarRuntime.mjs`
  - 适配层：`adapters/codexAdapter.mjs`、`adapters/openClawLikeAdapter.mjs`
- **Platform API（Fastify）**
  - 入口：`apps/platform-api/src/app.ts`
  - 认证、M2、社交、支付、奖励等路由：`routes/*`

## 2) Runtime 关键链路
1. UI 调 `services/agent/agentGateway.ts`
2. 进入 `AgentRuntimeClient`（preload 暴露 API + 事件查询缓存）
3. Runtime 端根据模型路由：
   - `runtimeModelRouting.mjs` 判定 `managed / openai-compatible / codex-sidecar`
4. 若 Codex 可用：`codexSidecarRuntime.mjs` 执行 thread/turn/tool 循环
5. 否则降级到 local runtime（`index.ts` + `AiService`）

## 3) Event Center / Timeline / 审计
- 客户端事件工具：`services/agent/runtimeEventCenter.ts`
  - 过滤、分页游标、导出 JSON
  - memory.recall telemetry 聚合报告
- 时间线映射：`services/agent/runtimeEventTimeline.ts`
  - 把 `turn/tool/artifact/memory` 事件映射成可读状态
- Runtime 审计环形缓冲：
  - local 与 sidecar 都维护 event audit（max 2000）

## 4) Memory 子系统（已实现）
- `services/memory/memoryService.ts`
  - mid/long 双层目录
  - 写入策略（长度、敏感词、去重窗口）
  - recall 打分（token hit + 衰减 + task-layer 权重）
  - telemetry（scanned/matched/selected/conflict）

## 5) Scheduler / 自治策略
- `services/scheduler/autonomyPolicy.ts`
- 模板：`config/scheduler-autonomy.templates.json`
  - cron + heartbeat + retry/backoff + stopRule

## 6) Web-IM / 远程社交
- 前端窗口：`components/PlatformSocialWindow.tsx`
  - 绑定、会话、3s 轮询、发送去重
- 客户端 API：`services/platformUserService.ts`
- 后端路由：`apps/platform-api/src/routes/socialRoutes.ts`
  - 同时挂载 `/api/v1/social` 和 `/api/v1/web-im`
- 后端存储服务：`services/remoteSocialService.ts`（JSON store + 写串行锁）

## 7) Auth / Model Routing / Billing
- 鉴权插件：`plugins/authPlugin.ts`（jwt + sessionVersion + active user）
- auth 路由：`routes/authRoutes.ts`
- M2 路由：`routes/m2Routes.ts`
  - `managed/byok` 双模式
  - managed target 解析（current/preset/baseUrl+model 命中）
  - 账本与 token 消耗联动

## 8) Tooling / Release
- Dev 编排：`scripts/runDevFlow.mjs`、`platformStackDev.mjs`
- Gate 脚本集中在 `scripts/test_*.mjs|ts`
- 发布就绪与回滚：
  - `scripts/release_451x_readiness.mjs`
  - `scripts/release_rollback_451x.mjs`
