---
name: tech-report
description: Build a repeatable troubleshooting report loop: search → fetch → open → screenshot → produce a structured report with evidence.
---

# tech-report

## Purpose
Turn **web search + page fetch + browser screenshot** into a repeatable troubleshooting report with evidence.

## When to use
- Production/staging/local issues: stuck UI, errors, API unavailable, perf regression
- You need a reproducible, accountable report: **links + fetched content + screenshots + structured write-up**

## Tools & Schema-first (required)
**Schema-first rule (mandatory):** before calling any tool, always call `listTools` first and read each tool's `inputSchema`. **Do not hardcode** tool names or arguments; derive the correct tool + params from `listTools` + `inputSchema`.

Typically involved tool families (example): web search/fetch + browser automation + file I/O.

## Procedure
1. Search: collect top results (URLs + snippets).
2. Fetch: download and extract readable text for the most relevant pages.
3. Open: open key pages in a browser.
4. Screenshot: capture evidence.
5. Report: generate a fixed-structure markdown report and save artifacts.

## Examples
Run via deterministic script (recommended):

```bash
npm run tech:report -- --query "OpenClaw gateway status" --symptom "gateway status 报错/启动失败" --limit 5
```

Outputs:
- `test/tech_report.md`
- `test/tech_report.png`

## Safety
- Do not include secrets/tokens from fetched pages or screenshots.
- Prefer deterministic scripts over manual UI clicking to reduce flakiness.
- If the environment is production, avoid actions that could mutate state.

## Changelog
- v1: Standardized SKILL.md template + schema-first rule section.
