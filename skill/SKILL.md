---
name: system-check
description: Run before complex skills to verify required skills, MCPs, commands, paths, roots, env vars, and manifests are available before expensive work starts.
---

# System Check

Use this skill before invoking any complex skill.

## Purpose

`system-check` is a light preflight gate. It verifies that declared requirements appear available before a complex skill starts using subskills, MCPs, subagents, external commands, network/API/auth flows, long workflows, or multi-file deliverables.

This skill saves resources. If a required item fails, complete the whole checklist, report the failed requirement, then stop before running the target skill unless the user clearly says to proceed.

## Complex Skill Definition

A skill is complex if it uses any of these:

- subskills or chained skills
- MCPs, apps, connectors, or tool namespaces
- subagents or parallel agents
- external CLIs or local commands
- fixed project roots or helper scripts
- network, API, auth, or paid-service access
- long-running workflows
- multi-file or packaged deliverables

## Requirement Lookup Order

For the target skill, find requirements in this order:

1. Inline `## System Check Requirements` section in the target skill's `SKILL.md`
2. Sidecar cache at `~/.codex/system-check/manifests/<skill-name>.md`
3. Missing-manifest fallback

If a complex skill has no inline or cached manifest, the missing manifest is a failed required item.

## Manifest Format

Requirements are simple lines:

```markdown
## System Check Requirements
- required skill: seo-firecrawl
- required mcp: google_search_console | mcp__google_search_console
- required command: python
- optional env: PAGESPEED_API_KEY
- required project-root: D:\AI\SEO-AUDIT-ORIGINAL
- required path: D:\AI\SEO-AUDIT-ORIGINAL\scripts\check_deps.py
- note: PageSpeed checks are skipped if the API key is unavailable
```

Rules:

- Missing severity means `required`.
- Failed `required` items block execution.
- Failed `optional` items are listed but do not block.
- `note` items are informational and do not pass or fail.
- Aliases use `|`; any passing alias satisfies the item.
- Environment variable values must never be printed.

## Light Check Types

- `skill`: skill exists in the session list or has a readable `SKILL.md`
- `mcp`: MCP/tool namespace is visible in the current session
- `command`: command is discoverable with the local shell
- `path`: file or directory exists
- `project-root`: directory exists
- `env`: environment variable is present
- `note`: informational only

Do not run expensive readiness checks by default. Avoid API calls, auth probes, crawls, installs, downloads, paid service calls, or long test suites.

## Procedure

1. Identify the target complex skill.
2. Locate its requirements manifest using the lookup order.
3. If no manifest exists, print the missing-manifest checklist and ask for the target skill's local path or GitHub remote/source, then stop.
4. If the user provides a local path, inspect that local source first. If the user provides a remote/source URL, inspect it only after following current web/GitHub routing and approval rules.
5. Search source material for `Requirements`, `Dependencies`, `MCP`, `MCP integrations`, `Extensions`, `Tools`, `Environment variables`, `API keys`, `Setup`, `Install`, `Prerequisites`, `Subagents`, `Scripts`, `Project root`, `Commands`, and `Auth`.
6. Synthesize a manifest from the discovered requirements.
7. Save the manifest to `~/.codex/system-check/manifests/<skill-name>.md` by default. Only update a skill file inline when the user explicitly requests a skill maintenance edit.
8. Rerun the light checklist from the saved manifest.
9. If all required items pass, print `System check: all green - proceeding.` and continue.
10. If any required item fails, list all results, print each failed required item, ask `Proceed or stop?`, and stop unless the user clearly says proceed.

## Required Output Format

Passing:

```text
System check: <skill-name>

[pass] required skill: seo-firecrawl
[pass] required command: python
[pass] optional env: PAGESPEED_API_KEY

System check: all green - proceeding.
```

Failing:

```text
System check: <skill-name>

[pass] required skill: seo-firecrawl
[fail] required mcp: google_search_console | mcp__google_search_console
[pass] required command: python
[note] PageSpeed checks are skipped if the API key is unavailable

This requirement failed - required mcp: google_search_console | mcp__google_search_console

Proceed or stop?
```

Missing manifest:

```text
System check: <skill-name>

[fail] required manifest: no System Check Requirements section or sidecar manifest found

This requirement failed - manifest missing.

Provide the skill local path or GitHub remote/source so I can inspect requirements, or choose stop.
Proceed or stop?
```

## Safety Rules

- Always complete the checklist before stopping.
- Default to stop when a required item fails.
- Do not print secrets or environment variable values.
- Do not use network, GitHub, or web inspection unless the user provides or approves the source for that missing-manifest recovery.
- Prefer local path inspection over remote inspection when both are available.
- Do not execute the target complex skill until the system check passes or the user explicitly approves proceeding after failure.
