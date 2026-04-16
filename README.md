# systems-check

<p align="center">
  <a href="https://github.com/2slowDD/systems-check/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/2slowDD/systems-check/ci.yml?branch=main&label=CI&style=for-the-badge"></a>
  <img alt="Claude Code Skill" src="https://img.shields.io/badge/Claude%20Code-Skill-5A32A3?style=for-the-badge">
  <img alt="Codex Skill" src="https://img.shields.io/badge/Codex-Skill-111111?style=for-the-badge">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"></a>
  <img alt="Version 0.1.0" src="https://img.shields.io/badge/Version-0.1.0-blue?style=for-the-badge">
</p>

<p align="center">
  <strong>A light preflight gate for complex AI skills.</strong>
</p>

`systems-check` packages the `system-check` Codex skill: a lightweight preflight gate for complex AI skills.

Before a complex skill starts using subskills, MCPs, external commands, helper scripts, project roots, auth flows, or long workflows, `system-check` verifies that declared requirements appear available. If anything required is missing, it completes the checklist and stops before expensive work begins.

## What It Does

- Checks requirements declared by complex skills.
- Lists every item with `[pass]`, `[fail]`, or `[note]`.
- Stops on failed required items unless the user clearly approves proceeding.
- Never prints environment variable values.
- Avoids network, auth, API, install, or paid-service checks by default.
- Caches discovered manifests in a sidecar location instead of mutating skill files during preflight.

## Install For Codex

### Codex: Windows PowerShell

From the repository root:

```powershell
.\scripts\install.ps1
```

This copies `skill\SKILL.md` to:

```text
$env:USERPROFILE\.codex\skills\system-check\SKILL.md
```

### Codex: macOS/Linux Shell

From the repository root:

```sh
sh scripts/install.sh
```

This copies `skill/SKILL.md` to:

```text
$HOME/.codex/skills/system-check/SKILL.md
```

Restart your Codex session after installing so the skill list refreshes.

## Install For Claude

Claude skill installations commonly use:

```text
$HOME/.claude/skills/<skill-name>/SKILL.md
```

or on Windows:

```text
$env:USERPROFILE\.claude\skills\<skill-name>\SKILL.md
```

### Claude: Windows PowerShell

From the repository root:

```powershell
.\scripts\install-claude.ps1
```

This copies `skill\SKILL.md` to:

```text
$env:USERPROFILE\.claude\skills\system-check\SKILL.md
```

### Claude: macOS/Linux Shell

From the repository root:

```sh
sh scripts/install-claude.sh
```

This copies `skill/SKILL.md` to:

```text
$HOME/.claude/skills/system-check/SKILL.md
```

Restart your Claude session after installing so the skill list refreshes.

## Add The Global Hook

Add this rule to your `AGENTS.md` or equivalent agent instructions:

```markdown
## System Check For Complex Skills

Before invoking any complex skill other than `system-check` itself, run the `system-check` skill against that skill's declared requirements.

A skill is complex if it uses subskills, MCPs/apps/connectors, subagents, external CLIs, fixed project roots, helper scripts, network/API/auth, long-running workflows, or multi-file deliverables.

If all required items pass, print `System check: all green - proceeding.` and continue.

If any required item fails, complete the checklist, print all failed required items one per line as `This requirement failed - <name>`, ask `Proceed or stop?`, and stop unless the user clearly approves proceeding.

If a complex skill has no inline or cached requirements manifest, treat the missing manifest as a failed requirement. Inspect the skill's local `SKILL.md` if available; otherwise ask for the skill's local path or GitHub remote/source so requirements can be inspected and cached.
```

## Manifest Format

Complex skills declare their preflight requirements in `SKILL.md`:

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

See [examples/system-check-requirements-example.md](examples/system-check-requirements-example.md) for a reusable template.

## Security Model

`system-check` is intentionally conservative:

- It performs light availability checks only.
- It treats missing manifests as failures.
- It defaults to stopping on failed required checks.
- It does not print secret values.
- It does not perform network or GitHub inspection unless the user provides or approves the source.
- It prefers local source inspection over remote source inspection.

See [SECURITY.md](SECURITY.md) for reporting and review guidance.

## Repository Layout

```text
skill/SKILL.md                         # Installable Codex skill
examples/system-check-requirements-example.md
scripts/install.ps1                    # Windows installer
scripts/install.sh                     # macOS/Linux installer
scripts/install-claude.ps1             # Windows Claude installer
scripts/install-claude.sh              # macOS/Linux Claude installer
docs/SECURITY-CHECK.md                 # Local security review notes
.github/ISSUE_TEMPLATE/bug_report.md
.github/ISSUE_TEMPLATE/feature_request.md
.github/pull_request_template.md
CHANGELOG.md
CODE_OF_CONDUCT.md
SECURITY.md
CONTRIBUTING.md
LICENSE
```

## Version

Current release: `0.1.0`
