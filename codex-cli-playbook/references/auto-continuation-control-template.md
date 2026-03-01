# Auto-Continuation Control Template

> 目标：把“自动续跑”变成可审计、可中断、可收口的执行协议。

## 1) Same-turn handoff rule（同回合交接）
在同一回合一次性下发三件事：
1. 当前阶段目标（可验收）
2. 证据契约（必须回传的原始证据）
3. 下一阶段触发条件（何时自动切换）

缺任一项则不得进入执行态。

## 2) RunId proof rule（runId 取证）
每个阶段必须绑定唯一 `runId`，并在里程碑中原样给出：
- `runId`
- 启动命令（可复制）
- 关键命令原始输出（stdout/stderr，不改写）
- 对应 commit hash

无 `runId` 或仅口头转述输出，一律判定为“证据不足”。

## 3) Milestone report format（里程碑格式，中文证据优先）
```md
## [阶段名] 里程碑（T+xx）
- 结论：完成 / 部分完成 / 阻塞
- runId：<runId>
- Commit：<hash>
- 产出：<文件/制品>

### 执行命令（原文）
```bash
<cmd1>
<cmd2>
```

### 原始输出（原文）
```text
<raw stdout/stderr>
```

### 验收对照
- [x] 条件A（证据：...）
- [ ] 条件B（阻塞：...）

### 下一步
- 满足触发条件：切换到 <下一阶段>
- 不满足：进入阻塞协议
```

## 4) Blocker handling protocol（阻塞处理）
触发：重复失败、权限/依赖缺失、结果与验收冲突。

动作：
1. 冻结完成百分比（禁止继续报进度）
2. 记录 blocker 类型、影响面、已尝试方案
3. 发起最小解阻请求（仅请求必要输入/权限）
4. 如可降级，给出降级路径与风险说明

## 5) Completion-scan closure rule（收口扫描）
最终阶段完成后必须执行 completion scan：
- 扫描：目标目录、任务清单、验收条目
- 输出：完成项 / 未完成项 / 风险项 / 范围外项

仅当“无未解释缺口”时，允许关闭该批次。

## 6) PowerShell guardrails（`;` / `$LASTEXITCODE` / 禁用 `&&`）
- 允许 `;` 进行顺序执行，不代表成功链路。
- 关键步骤后必须检查退出码：
  ```powershell
  <command>
  if ($LASTEXITCODE -ne 0) { throw "step failed: <name>" }
  ```
- 禁止使用 `&&`/`||` 作为成功失败控制主干。
- 推荐：
  ```powershell
  $ErrorActionPreference = 'Stop'
  ```
- 关键里程碑命令必须回传原始输出，确保可审计。
