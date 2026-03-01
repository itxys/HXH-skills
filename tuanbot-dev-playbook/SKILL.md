---
name: tuanbot-dev-playbook
description: Tuanbot 架构理解与高效优化执行手册。用于架构盘点、Runtime/Memory/Scheduler/Web-IM 优化、发布门禁与证据化交付。
---

# Tuanbot Dev Playbook

## 何时触发（Trigger Phrases）
- “先做架构盘点/代码理解再改”
- “按门禁推进，不要盲改”
- “给我可执行优化方案 + 验证命令 + 证据”
- “按 Runtime/Memory/Scheduler/Web-IM 做专项优化”

## 默认执行协议（短版）
1. **先证据后结论**：先定位代码入口与脚本，再给判断。
2. **最小改动**：优先文档/配置/脚本，不改无关行为。
3. **门禁驱动**：每个里程碑必须带验证命令和结果。
4. **可回滚**：涉及发布/端口/路由时附 rollback 路径。

## 快速命令（最常用）
```bash
# 仓库根目录 D:\AI_PJ\ai-robots
npm run platform:stack:status
npm run test:gate:runtime-event-center
npm run test:gate:memory-layering
npm run test:gate:scheduler-autonomy
npm run test:gate:platform-social-p3
npm run test:gate:openclaw-parity-matrix
npm run release:451x:readiness
```

## 交付门禁（Gate Checklist）
- [ ] 架构影响范围已标注（runtime / memory / scheduler / web-im / auth / release）
- [ ] 关键路径有对应 gate 或等价验证命令
- [ ] 风险项写明触发条件 + 观测信号 + 回滚动作
- [ ] 输出包含 commit、命令、结果、剩余风险

## 证据优先汇报模板（Evidence-first）
```md
### 里程碑 X：<目标>
- 变更：<文件/模块>
- 证据：
  - commit: <hash>
  - command: <cmd>
  - result: PASS/FAIL + 关键输出
- 风险：<已知风险>
- 下一步：<单句>
```

## 逐层展开（Progressive Disclosure）
- 架构地图：`references/architecture-map.md`
- Runtime 路由：`references/runtime-routing.md`
- 门禁矩阵：`references/gate-matrix.md`
- 性能检查：`references/perf-checklist.md`
- 发布检查：`references/release-checklist.md`
- 开发红线：`references/dev-redlines.md`（连续执行、前置校验、截图验收、脏工作树隔离）
- 事故复盘与高频坑：`references/incident-lessons.md`（Web-IM 超时、HTTPS/API 路由、会议室路由、全局输入回归）
