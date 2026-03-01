# Performance Checklist（Runtime + UI）

## 1) 先采样再优化
- 读取：`services/runtimePerfTelemetry.ts`
- 核心指标：`app_bootstrap / interactive_ready / render_hotspot / memory_sample`

## 2) 基线与回归命令
```bash
npm run perf:runtime:baseline
npm run test:gate:runtime-baseline
npm run test:gate:runtime-ux-perf
npm run test:gate:robot-scaling
npm run bundle:report
npm run bundle:check
```

## 3) 常见瓶颈路径
- 长会话：event list + timeline 聚合 + UI 重绘
- 工具链：MCP 调用重试/超时导致 turn 拉长
- 社交轮询：3s polling + 消息去重策略

## 4) 决策规则
- 无基线证据，不做“已优化”结论。
- 优先降抖动/尾延迟，再追平均值。
- 性能优化必须附回归 gate（至少 1 个）。
