---
name: <skill-slug>
description: <one-sentence description of what this skill does and when to use it>
---

# <Skill Name>

## Purpose
What this skill is for (1-3 lines).

## When to use
- Situations where this skill should be chosen
- Situations where it should NOT be chosen

## Tools & Schema-first (required)
**Schema-first rule (mandatory):** before calling any tool, always call `listTools` first and read each tool's `inputSchema`. **Do not hardcode** tool names or arguments; derive the correct tool + params from `listTools` + `inputSchema`.

List the tool families you expect to use (if applicable).

## Procedure
Step-by-step process.

## Examples
At least 1 example input and what the expected output looks like.

## Safety
Key constraints, boundaries, and anything that requires human confirmation.

## Changelog
- v1: Initial template
