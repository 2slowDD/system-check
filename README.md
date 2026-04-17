# systems-check

<p align="center">
  <a href="https://github.com/2slowDD/system-check/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/2slowDD/system-check/ci.yml?branch=main&label=CI&style=for-the-badge"></a>
  <img alt="Claude Code Skill" src="https://img.shields.io/badge/Claude%20Code-Skill-5A32A3?style=for-the-badge">
  <img alt="Codex Skill" src="https://img.shields.io/badge/Codex-Skill-111111?style=for-the-badge">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"></a>
  <img alt="Version 0.1.5" src="https://img.shields.io/badge/Version-0.1.5-blue?style=for-the-badge">
</p>

<p align="center">
  <strong>A light preflight gate for complex AI skills.</strong>
</p>

`systems-check` packages the `system-check` Codex skill: a lightweight preflight gate for complex AI skills.

Before a complex skill starts using subskills, MCPs, external commands, helper scripts, project roots, auth flows, or long workflows, `system-check` verifies that declared requirements appear available. If anything required is missing, it completes the checklist and stops before expensive work begins.

![Example system-check output](system%20check%20example.jpg)

## What It Does

- Runs only when manually invoked with `sc-<target skill>`.
- Checks requirements declared by targeted complex skills.
- Lists every item with `✅`, `❌`, or `ℹ️`.
- Stops on failed required items unless the user clearly approves proceeding.
- Reports optional gaps separately instead of calling a checklist "all green."
- Offers post-send target suggestions when invoked as `sc-` or `sc-<partial>`.
- Never prints environment variable values.
- Avoids network, auth, API, install, or paid-service checks by default.
- Saves generated manifests to sidecar cache by default and preference, with user override options for inline save or no save.

## Install For Codex

| Action | Windows PowerShell | macOS/Linux Shell |
| ------ | ------------------ | ----------------- |
| Install | `.\scripts\install.ps1` | `sh scripts/install.sh` |
| Sync from repo | `.\scripts\sync.ps1` | `sh scripts/sync.sh` |
| Uninstall | `.\scripts\uninstall.ps1` | `sh scripts/uninstall.sh` |

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

### Codex: Smoke Test

After restarting Codex, send this as a message:

```text
sc-
```

That means type `sc-` + Enter. Nothing appears while typing because skills run only after a message is submitted. After you submit `sc-`, the assistant should list available `system-check` targets and wait for you to choose one.

## Install For Claude

| Action | Windows PowerShell | macOS/Linux Shell |
| ------ | ------------------ | ----------------- |
| Install | `.\scripts\install-claude.ps1` | `sh scripts/install-claude.sh` |
| Sync from repo | `.\scripts\sync-claude.ps1` | `sh scripts/sync-claude.sh` |
| Uninstall | `.\scripts\uninstall-claude.ps1` | `sh scripts/uninstall-claude.sh` |

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

Uninstall removes only the installed `system-check` skill. Cached manifests are preserved.

## Manual Usage

`system-check` does not run automatically before complex skills.

Invoke it manually with:

```text
sc-<target skill>
```

Examples:

```text
sc-SEO audit
sc-Brainstorming
sc-systematic-debugging
```

Normal skill invocation, such as `SEO audit`, does not trigger `system-check`.

### Sync The Installed Skill

Use `system-check-sync` to check whether the local `systems-check` source repository is current with `origin/main`.

When the source repository is clean and behind the remote, `system-check-sync` fast-forwards it with `git pull --ff-only`, then refreshes the installed skill for the current host:

- Codex: `scripts\sync.ps1` or `scripts/sync.sh`
- Claude: `scripts\sync-claude.ps1` or `scripts/sync-claude.sh`

`system-check-sync` stops instead of updating when the working tree is dirty, the local branch is ahead, or the branch has diverged. It never pushes, force-pushes, rebases, resets, or deletes files.

## Target Suggestions

Send `sc-` to ask the assistant for available system-check targets. Send `sc-<partial>`, such as `sc-fire`, to get matching skills before choosing one.

These are post-send assistant target suggestions: the skill can suggest targets after you submit a message. Nothing appears while typing in the composer. Native typeahead while typing requires support from the host AI client.

Add this manual-only rule to your `AGENTS.md` or equivalent agent instructions:

```markdown
## Manual System Check

Do not run `system-check` automatically before complex skills.

Run it only when the user explicitly invokes a manual check using `sc-<target skill>`, such as `sc-SEO audit` or `sc-Brainstorming`.

When `sc-<target skill>` is invoked, treat everything after `sc-` as the target skill name and use the `system-check` skill to resolve and check that target.
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

## Automatic Manifest Bootstrap

When a targeted skill has no manifest, `system-check` can generate one from the local skill source.

The flow is:

1. Inspect local `SKILL.md` when available.
2. Infer a draft manifest from dependency signals.
3. Show the draft for review.
4. Ask where to save it:
   - `1. Sidecar cache (default, preferred)`
   - `2. Inline skill file`
   - `3. Do not save`
5. Rerun the system check from the saved manifest.

Generated manifests save to sidecar cache by default:

```text
~/.codex/system-check/manifests/<skill-name>.md
```

The sidecar cache is the preferred save target because it avoids silently editing the target skill while keeping future checks reusable. The user can override this and choose inline save or no save when prompted.

Remote or GitHub source inspection only happens after the user provides or approves the source.

## Security Model

`system-check` is intentionally conservative:

- It performs light availability checks only.
- It treats missing manifests as failures.
- It defaults to stopping on failed required checks.
- It does not print secret values.
- It does not perform network or GitHub inspection unless the user provides or approves the source.
- It prefers local source inspection over remote source inspection.
- It does not run automatically before complex skills.
- It preserves cached manifests during uninstall.

See [SECURITY.md](SECURITY.md) for reporting and review guidance.

## Repository Layout

```text
skill/SKILL.md                         # Installable Codex skill
examples/system-check-requirements-example.md
scripts/install.ps1                    # Windows installer
scripts/install.sh                     # macOS/Linux installer
scripts/install-claude.ps1             # Windows Claude installer
scripts/install-claude.sh              # macOS/Linux Claude installer
scripts/sync.ps1                       # Windows Codex sync
scripts/sync.sh                        # macOS/Linux Codex sync
scripts/sync-claude.ps1                # Windows Claude sync
scripts/sync-claude.sh                 # macOS/Linux Claude sync
scripts/uninstall.ps1                  # Windows Codex uninstall
scripts/uninstall.sh                   # macOS/Linux Codex uninstall
scripts/uninstall-claude.ps1           # Windows Claude uninstall
scripts/uninstall-claude.sh            # macOS/Linux Claude uninstall
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

Current release: `0.1.5`
