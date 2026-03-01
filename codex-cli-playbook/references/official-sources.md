# Official sources used (deep refresh)

## Primary docs (official)
- Docs hub: https://developers.openai.com/codex/
- CLI: https://developers.openai.com/codex/cli
- CLI features: https://developers.openai.com/codex/cli/features
- Auth: https://developers.openai.com/codex/auth
- Config basics: https://developers.openai.com/codex/config-basic
- Config advanced: https://developers.openai.com/codex/config-advanced
- Config reference: https://developers.openai.com/codex/config-reference
- MCP: https://developers.openai.com/codex/mcp
- SDK: https://developers.openai.com/codex/sdk
- Security: https://developers.openai.com/codex/security
- Windows: https://developers.openai.com/codex/windows
- Changelog: https://developers.openai.com/codex/changelog

## Official repo references
- Repo: https://github.com/openai/codex
- README: https://raw.githubusercontent.com/openai/codex/main/README.md
- config.md: https://raw.githubusercontent.com/openai/codex/main/docs/config.md

## Key confirmed points used in this skill
- CLI install/upgrade via npm.
- Interactive + `exec` non-interactive modes.
- Resume flows (`codex resume`, `codex exec resume`).
- Auth supports ChatGPT sign-in and API key mode; device-auth exists.
- Config layering + project trust behavior.
- Approval/sandbox policy matrix and risk tradeoffs.
- MCP setup via CLI/config and timeout/tool controls.
- Windows guidance prefers WSL for best experience.

## Notes
- Docs pages can evolve quickly; re-check changelog for behavior changes before strict automation.
