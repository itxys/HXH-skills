---
name: deep-researcher
description: 深度搜索与信息采集技能。当用户有搜索需求时：(1) 若有明确 URL，使用 web_fetch 抓取；(2) 若是简单事实查询，使用 web_search；(3) 若问题复杂、多元或需要深度研究，使用 codex cli 进行多轮深度搜索。
---

# Deep Researcher (深度搜索者)

本技能用于根据问题的复杂度，自动选择最优的搜索策略。

## 决策逻辑 (Decision Tree)

1.  **有明确 URL？**
    - 动作：直接调用 `web_fetch(url)`。
    - 适用：用户提供了具体参考链接，需要读取详情。

2.  **简单事实查询？**
    - 动作：使用 `web_search(query)`。
    - 适用：查询定义、日期、简单事实、天气等。

3.  **复杂/多元/深度研究？**
    - 动作：使用 `codex exec "deep search <query>"` 或通过 `sessions_spawn` 启动多轮搜索任务。
    - 适用：行业调研、技术选型对比、多维度方案分析、需要跨多个网站汇总信息的情况。

## 执行规范

### 1. 简单搜索 (`web_search`)
- 优先查看 Brave Search 返回的 snippets。
- 若 snippets 不足，挑选 1-2 个高权重 URL 进行 `web_fetch`。

### 2. 深度搜索 (`codex-cli`)
- 使用 `codex exec` 并开启 `--search`。
- 引导 Codex 进行：**分解问题 -> 分步骤搜索 -> 汇总对比 -> 产出深度报告**。

## 汇报格式
- **搜索结论**：简明扼要的核心回答。
- **参考来源**：列出关键 URL。
- **详细分析**（仅深度搜索）：多维度的对比或深度解读。
