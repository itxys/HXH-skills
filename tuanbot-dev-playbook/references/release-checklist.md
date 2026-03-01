# Release Checklist（451x + Runtime 路由）

## 发布前
1. 端口一致性：4510/4512/4514
2. 运行健康：`npm run platform:stack:status`
3. 核心 gate：`npm run platform:gate`
4. 韧性 gate：`npm run test:gate:resilience-e2e`
5. 发布就绪：`npm run release:451x:readiness`

## 发布后快速验证
- `GET /api/v1/health` 正常
- 登录/鉴权刷新正常
- managed/byok 聊天路径均可达
- Web-IM 绑定/会话/轮询/发送可用

## 回滚
- 执行：`npm run release:451x:rollback:dry`
- 对照脚本 `scripts/release_rollback_451x.mjs` 检查 8 步：
  - 冻结流量 -> 快照 -> 回退构建 -> 恢复策略 -> 重启栈 -> health+smoke -> 路由验证 -> 事故归档

## 风险重点
- managed key 缺失会导致 503/402 路径波动
- sidecar 主会话失效会触发 runtime 降级
- 端口被占但服务不健康时，stack 启动会硬失败
