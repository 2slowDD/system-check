---
name: system-check
description: Run before complex skills to verify required skills, MCPs, commands, paths, roots, env vars, and manifests are available before expensive work starts.
---

# System Check

Use this skill only when the user explicitly invokes a manual check with `sc-<target skill>`, such as `sc-SEO audit` or `sc-Brainstorming`.

Normal skill invocation must not trigger `system-check`.

## Purpose

`system-check` is a light manual preflight gate. It verifies that declared requirements appear available before a user chooses to run a complex skill that uses subskills, MCPs, subagents, external commands, network/API/auth flows, long workflows, or multi-file deliverables.

This skill saves resources. If a required item fails, complete the whole checklist, report the failed requirement, then stop before running the target skill unless the user clearly says to proceed.

## Manual Invocation

The user invokes this skill with:

```text
sc-<target skill>
```

Everything after `sc-` is treated as the target skill name.

Examples:

```text
sc-SEO audit
sc-Brainstorming
sc-systematic-debugging
sc-github fix ci
```

Do not run `system-check` when the user invokes the target skill normally.

## Autocomplete / Partial Invocation

This skill cannot add native typeahead to the chat composer by itself. True typeahead requires host client support from Codex, Claude, or another AI client.

When the user sends exactly `sc-`, treat it as an autocomplete request:

1. List all available skills from the current session inventory, grouped by source when the source is known.
2. If the current session inventory is unavailable or obviously incomplete, scan known local skill roots for this AI setup as a fallback.
3. Ask the user to reply with a number or a full `sc-<target skill>` invocation.
4. Do not run any system check until the user chooses a target.

When the user message starts with `sc-` and the suffix is partial, such as `sc-fire` or `sc-seo-g`, treat it as an autocomplete request before normal target resolution:

1. Match the suffix against skill names with the same normalization used by Target Resolution.
2. Prefer current-session skills over fallback filesystem discoveries.
3. If there is one clear match, ask whether to run `sc-<matched skill>`.
4. If there are multiple matches, show a numbered list and ask the user to choose.
5. If there are no matches, continue with the existing missing-target behavior.

For Codex fallback scans, check likely local roots such as `~/.codex/skills`, `~/.codex/superpowers/skills`, and `~/.agents/skills`. For Claude fallback scans, check the current Claude skill inventory first, then known local Claude skill roots when available.

## Target Resolution

Resolve the target skill in this order:

1. Exact skill name match
2. Case-insensitive normalized match
3. Space, hyphen, and underscore normalized match
4. Description/name fuzzy match when one target is clearly best
5. Ask the user to choose if multiple candidates are plausible

If no target can be found, ask for a local `SKILL.md` path or source URL.

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

If a manually targeted complex skill has no inline or cached manifest, the missing manifest is a failed required item.

## Bootstrap Missing Manifests

When a manually targeted complex skill has no inline or cached manifest, enter bootstrap mode immediately if local skill source is available.

1. Treat the missing manifest as a failed required item.
2. Inspect the target local `SKILL.md` first if it is available.
3. If the local source is unavailable or insufficient, ask for the local path or GitHub/source URL.
4. Inspect remote or GitHub source only after the current routing and approval rules allow it.
5. Search for dependency signals in requirements, dependencies, MCP integrations, extensions, tools, environment variables, API keys, setup, install, prerequisites, subagents, scripts, project root, commands, auth, command snippets, helper paths, and referenced skill names.
6. Generate a draft `## System Check Requirements` section from the discovered signals.
7. Show the draft to the user.
8. Ask where to save it: `1. Sidecar cache (default, preferred)`, `2. Inline skill file`, or `3. Do not save`.
9. Save only after the user chooses a target.
10. Rerun the check from the saved manifest.
11. If the user chooses not to save, stop unless the user explicitly approves proceeding without a manifest.

If the user presses enter or gives an ambiguous save response, use sidecar cache.

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

## Manifest Inference Rules

- Prefer conservative inference. Only include an item when the source material supports it.
- `required command`, `required path`, `required project-root`, and `required skill` are required only when the dependency is explicit or strongly implied by setup, scripts, helper paths, or referenced skill names.
- `required mcp` and `optional mcp` depend on whether the dependency is needed for the skill to function or is merely an alternate or situational integration.
- `required env` and `optional env` must use environment variable names only. Never include secret values, tokens, or sample credentials.
- `note` lines are for context, caveats, and skipped checks only. They never block execution.
- Use `optional` only when the source clearly marks a dependency as non-blocking, fallback-only, or conditional.
- Add confidence comments sparingly when they help later review.

Examples:

```markdown
## System Check Requirements
- required command: python # confidence: high, found in setup script
- required path: D:\AI\Project\scripts\check_deps.py # confidence: medium, referenced by helper docs
- optional env: PAGESPEED_API_KEY # confidence: low, used only for enhanced reporting
- note: API calls are skipped when the key is missing
```

## Procedure

1. If the user sent `sc-` or a partial `sc-<partial>` invocation, handle Autocomplete / Partial Invocation first.
2. Identify the target complex skill.
3. Locate its requirements manifest using the lookup order.
4. If no manifest exists, enter bootstrap mode and print the missing-manifest checklist.
5. Inspect the target local `SKILL.md` first if it is available.
6. Ask for the local path or GitHub/source URL only if the local source is unavailable or insufficient.
7. Inspect remote or GitHub source only after the current routing and approval rules allow it.
8. Search source material for `Requirements`, `Dependencies`, `MCP`, `MCP integrations`, `Extensions`, `Tools`, `Environment variables`, `API keys`, `Setup`, `Install`, `Prerequisites`, `Subagents`, `Scripts`, `Project root`, `Commands`, `Auth`, command snippets, helper paths, and referenced skill names.
9. Synthesize a draft manifest from the discovered requirements.
10. Show the draft to the user and ask where to save it: `1. Sidecar cache (default, preferred)`, `2. Inline skill file`, or `3. Do not save`.
11. Save the manifest only after the user chooses a target.
12. Rerun the light checklist from the saved manifest.
13. If all required and optional items pass, print `System check: all checks green - proceeding.` and continue.
14. If all required items pass but one or more optional items fail, print `System check: required items green; optional gaps found.` and continue. Do not call this "all green."
15. If any required item fails, list all results, print each failed required item, ask `Proceed or stop?`, and stop unless the user clearly says proceed.

## Required Output Format

Passing:

```text
System check: <skill-name>

✅ required skill: seo-firecrawl
✅ required command: python
✅ optional env: PAGESPEED_API_KEY

System check: all checks green - proceeding.
```

Passing with optional gaps:

```text
System check: <skill-name>

✅ required skill: seo-firecrawl
✅ required command: python
❌ optional mcp: dataforseo | mcp__dataforseo
ℹ️ DataForSEO enriches the audit when available.

System check: required items green; optional gaps found.
```

Failing:

```text
System check: <skill-name>

✅ required skill: seo-firecrawl
❌ required mcp: google_search_console | mcp__google_search_console
✅ required command: python
ℹ️ PageSpeed checks are skipped if the API key is unavailable

Required item failed - required mcp: google_search_console | mcp__google_search_console

Proceed or stop?
```

Bootstrap draft:

```text
System check: <skill-name>

❌ required manifest: no System Check Requirements section or sidecar manifest found
ℹ️ bootstrap draft generated from local SKILL.md and dependency signals

## System Check Requirements
- required command: python # confidence: high, found in setup script
- required path: D:\AI\ChatGPT\systems-check\scripts\check_deps.py # confidence: medium, referenced by helper docs
- optional env: PAGESPEED_API_KEY # confidence: low, used only for reporting
- note: API calls are skipped when the key is missing

Save where?
1. Sidecar cache (default, preferred)
2. Inline skill file
3. Do not save
```

Missing manifest:

```text
System check: <skill-name>

❌ required manifest: no System Check Requirements section or sidecar manifest found

Required item failed - manifest missing.

Provide the skill local path or GitHub remote/source so I can inspect requirements, or choose stop.
Proceed or stop?
```

## Safety Rules

- Always complete the checklist before stopping.
- Do not auto-run before complex skills.
- Run only when the user explicitly invokes `sc-<target skill>`.
- Treat exact `sc-` and partial `sc-<partial>` messages as autocomplete requests, not approval to run a check.
- Default to stop when a required item fails.
- Do not print secrets or environment variable values.
- Never silently edit a skill file.
- Use sidecar cache as the default and preferred generated-manifest save target.
- Ask before remote or GitHub source inspection.
- Do not use network, GitHub, or web inspection unless the user provides or approves the source for that missing-manifest recovery.
- Prefer local path inspection over remote inspection when both are available.
- Do not run expensive checks while generating a draft manifest.
- Never delete sidecar manifests during uninstall unless a separate explicit purge command exists.
- Do not execute the target skill until the saved manifest passes or the user explicitly approves proceeding without a manifest.
- Do not execute the target complex skill until the system check passes or the user explicitly approves proceeding after failure.
