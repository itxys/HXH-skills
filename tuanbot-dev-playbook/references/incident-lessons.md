# Tuanbot 线上问题复盘与关键经验（2026-02）

## 1) Web-IM 超时（60s）高频根因
- **现象**：`[超时] 任务执行超时（60s）`，消息长期 queued。
- **根因**：客户端 worker 进程掉线或无人消费（`tasks/pull` 无有效消费者）。
- **处理**：确保 `webim-itxys-worker.js` 常驻；恢复后应出现 `worker start` + `bound ok`。
- **长期措施**：必须上 `systemd/pm2` 守护与自恢复，避免“伪同步”。

## 2) 登录过期/互踢
- **现象**：Web-IM 与客户端互踢、频繁“登录已过期”。
- **根因**：会话类型与登录入口混用，导致 session 冲突。
- **处理经验**：worker 使用 `/api/v1/auth/login`，避免复用 `web-im/session/login` 语义。

## 3) 线上目录不是 git 仓库
- **现象**：服务器目录可运行但无法 `git pull`。
- **风险**：版本不可追溯、回滚困难。
- **处理**：前端采用 `build -> zip/scp -> unzip 覆盖 /home/ubuntu/dist`。
- **长期措施**：改为“完整可回滚部署”（版本号、产物清单、回滚脚本）。

## 4) HTTP/HTTPS 与 API_BASE_MISCONFIGURED
- **现象**：客户端报 `API_BASE_MISCONFIGURED`，拿到 HTML 而非 JSON。
- **根因**：80 端口路由策略与 HTTPS 跳转冲突，`/api/*` 被错误导到页面。
- **处理经验**：
  - `wordsforai.com` 开启 HTTPS（443）+ 证书自动续期；
  - 保留旧客户端兼容：`http://IP/api/*` 必须继续反代到 `127.0.0.1:4312` 返回 JSON。

## 5) 移动端 Web-IM 体验（最关键）
- **高优先结论**：必须使用“Telegram Web 壳层范式”，不要补丁式修 CSS。
- **范式**：固定根壳层 + 单滚动容器 + 固定输入层 + `visualViewport` 键盘补偿。
- **验收红线**：无横向越界、无整页拖拽、键盘弹出输入栏始终可用。

## 6) 会议室链路经验
- **managed provider 报错根因**：managed 请求误进 runtime gate（runtime 不支持该路径）。
- **处理**：会议室中 managed 走 direct 平台链路，direct/provider 路由分流明确。
- **体验升级关键**：支持 `Stop Current/Stop All`、上下文注入可视化可切换、流式状态可见。

## 7) 输入系统回归（电量代币）
- **现象**：非聚焦窗口无法接收全局输入。
- **根因**：`uIOhook` 被默认关闭，退化为窗口内事件监听。
- **处理**：Windows 默认恢复全局 hook；保留 `DISABLE_UIOHOOK=1` 应急开关。

## 8) 执行与汇报纪律（必须）
- 不做“口头完成”，只做“证据完成”：commit + 命令 + 结果 + 风险 + next。
- 用户确认“连续执行模式”：里程碑汇报后自动衔接下一阶段，不停在等待。
- PowerShell 链式执行避免 `&&`，用 `;` + `$LASTEXITCODE` 显式判断。
- 每次发布后必须做真实链路验证：`chat -> tasks/pull -> tasks/result`。
