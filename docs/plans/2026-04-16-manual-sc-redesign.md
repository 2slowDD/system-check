# Manual `sc-*` Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign `system-check` so it runs only when manually invoked as `sc-<target skill>`, defaults generated manifests to sidecar cache, and documents install, uninstall, and sync for Codex and Claude.

**Architecture:** Update the Markdown skill source as the package source of truth, update the installed local Codex copy after verification, replace the local AGENTS automatic hook with a manual-only rule, and add uninstall/sync scripts plus docs.

**Tech Stack:** Markdown-based Codex/Claude skill instructions, PowerShell scripts, POSIX shell scripts, GitHub Actions validation.

---

## File Structure

- Modify: `D:\AI\ChatGPT\systems-check\skill\SKILL.md`
  - Manual `sc-*` invocation, target resolution, sidecar-default save behavior.
- Modify: `D:\AI\ChatGPT\AGENTS.md`
  - Replace automatic complex-skill preflight with manual-only `sc-*` instruction.
- Modify: `D:\AI\ChatGPT\systems-check\README.md`
  - Manual usage, install/uninstall/sync for Codex and Claude.
- Modify: `D:\AI\ChatGPT\systems-check\CHANGELOG.md`
  - Record manual trigger and lifecycle script changes.
- Modify: `D:\AI\ChatGPT\systems-check\docs\SECURITY-CHECK.md`
  - Add manual-only and manifest-preservation security notes.
- Modify: `D:\AI\ChatGPT\systems-check\.github\workflows\ci.yml`
  - Validate new shell scripts.
- Create: `D:\AI\ChatGPT\systems-check\scripts\uninstall.ps1`
- Create: `D:\AI\ChatGPT\systems-check\scripts\sync.ps1`
- Create: `D:\AI\ChatGPT\systems-check\scripts\uninstall.sh`
- Create: `D:\AI\ChatGPT\systems-check\scripts\sync.sh`
- Create: `D:\AI\ChatGPT\systems-check\scripts\uninstall-claude.ps1`
- Create: `D:\AI\ChatGPT\systems-check\scripts\sync-claude.ps1`
- Create: `D:\AI\ChatGPT\systems-check\scripts\uninstall-claude.sh`
- Create: `D:\AI\ChatGPT\systems-check\scripts\sync-claude.sh`
- Modify: `C:\Users\dalib\.codex\skills\system-check\SKILL.md`
  - Installed local copy, updated after package verification.

### Task 1: Update Skill Instructions

**Files:**
- Modify: `D:\AI\ChatGPT\systems-check\skill\SKILL.md`

- [ ] **Step 1: Replace automatic purpose language**

Change the opening usage from automatic preflight language to manual invocation:

```markdown
Use this skill only when the user explicitly invokes a manual check with `sc-<target skill>`, such as `sc-SEO audit` or `sc-Brainstorming`.

Normal skill invocation must not trigger `system-check`.
```

- [ ] **Step 2: Add `Manual Invocation` section**

Add after `Purpose`:

```markdown
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
```

- [ ] **Step 3: Add `Target Resolution` section**

Add:

```markdown
## Target Resolution

Resolve the target skill in this order:

1. Exact skill name match
2. Case-insensitive normalized match
3. Space, hyphen, and underscore normalized match
4. Description/name fuzzy match when one target is clearly best
5. Ask the user to choose if multiple candidates are plausible

If no target can be found, ask for a local `SKILL.md` path or source URL.
```

- [ ] **Step 4: Make sidecar cache the default save target**

In bootstrap save-choice wording, use:

```text
Save where?
1. Sidecar cache (default)
2. Inline skill file
3. Do not save
```

Add:

```markdown
If the user presses enter or gives an ambiguous save response, use sidecar cache.
```

- [ ] **Step 5: Update safety rules**

Ensure safety rules include:

```markdown
- Do not auto-run before complex skills.
- Run only when the user explicitly invokes `sc-<target skill>`.
- Use sidecar cache as the default generated-manifest save target.
- Never delete sidecar manifests during uninstall unless a separate explicit purge command exists.
```

### Task 2: Replace Local AGENTS Hook

**Files:**
- Modify: `D:\AI\ChatGPT\AGENTS.md`

- [ ] **Step 1: Replace `System Check For Complex Skills` section**

Replace the current automatic-hook section with:

```markdown
## Manual System Check

Do not run `system-check` automatically before complex skills.

Run it only when the user explicitly invokes a manual check using `sc-<target skill>`, such as `sc-SEO audit` or `sc-Brainstorming`.

When `sc-<target skill>` is invoked, treat everything after `sc-` as the target skill name and use the `system-check` skill to resolve and check that target.
```

- [ ] **Step 2: Verify automatic hook text is gone**

Run:

```powershell
Select-String -Path 'D:\AI\ChatGPT\AGENTS.md' -Pattern '<old-automatic-hook-phrase>'
```

Expected: no matches.

### Task 3: Add Uninstall And Sync Scripts

**Files:**
- Create: scripts listed in File Structure

- [ ] **Step 1: Add Codex PowerShell uninstall**

Create `scripts\uninstall.ps1`:

```powershell
$ErrorActionPreference = 'Stop'

$TargetDir = Join-Path $env:USERPROFILE '.codex\skills\system-check'

if (Test-Path -LiteralPath $TargetDir) {
    Remove-Item -LiteralPath $TargetDir -Recurse -Force
    Write-Output "Removed system-check skill from $TargetDir"
} else {
    Write-Output "system-check skill is not installed at $TargetDir"
}

Write-Output "Cached manifests were not removed."
```

- [ ] **Step 2: Add Codex PowerShell sync**

Create `scripts\sync.ps1`:

```powershell
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Source = Join-Path $RepoRoot 'skill\SKILL.md'
$TargetDir = Join-Path $env:USERPROFILE '.codex\skills\system-check'
$Target = Join-Path $TargetDir 'SKILL.md'

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Source skill not found: $Source"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Copy-Item -LiteralPath $Source -Destination $Target -Force

Write-Output "Synced system-check skill to $Target"
Write-Output "Restart Codex so the skill list refreshes."
```

- [ ] **Step 3: Add Claude PowerShell scripts**

Create `scripts\uninstall-claude.ps1` and `scripts\sync-claude.ps1` using the same logic as Codex, but with `.claude\skills\system-check` and “Claude” in output.

- [ ] **Step 4: Add POSIX scripts**

Create `uninstall.sh`, `sync.sh`, `uninstall-claude.sh`, and `sync-claude.sh`.

Uninstall scripts remove only:

```text
$HOME/.codex/skills/system-check
$HOME/.claude/skills/system-check
```

Sync scripts copy:

```text
skill/SKILL.md
```

into the matching installed skill directory.

All uninstall scripts must print:

```text
Cached manifests were not removed.
```

### Task 4: Update README, Changelog, Security Notes, And CI

**Files:**
- Modify: `README.md`
- Modify: `CHANGELOG.md`
- Modify: `docs\SECURITY-CHECK.md`
- Modify: `.github\workflows\ci.yml`

- [ ] **Step 1: Replace README global-hook section**

Replace `Add The Global Hook` with `Manual Usage`:

```markdown
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
```

- [ ] **Step 2: Document sidecar default**

Add:

```markdown
Generated manifests save to sidecar cache by default:

```text
~/.codex/system-check/manifests/<skill-name>.md
```

The user can override this and choose inline save or no save when prompted.
```

- [ ] **Step 3: Add uninstall/sync command tables**

Add Codex and Claude command tables including install, sync, and uninstall for Windows and POSIX.

- [ ] **Step 4: Update changelog and security notes**

Add entries for:

- manual `sc-*` targeting
- removal of automatic preflight hook
- sidecar cache as default save target
- uninstall and sync scripts
- uninstall preserving cached manifests

- [ ] **Step 5: Update CI script checks**

Add all new `.sh` scripts to the `sh -n` check in `.github\workflows\ci.yml`.

### Task 5: Verify, Install Locally, And Commit

**Files:**
- Modify: `C:\Users\dalib\.codex\skills\system-check\SKILL.md`

- [ ] **Step 1: Run verification**

Run security scan, placeholder scan, PowerShell parser checks, POSIX shell parser checks, and Markdown fence balance.

Expected:

```text
no security pattern matches
no placeholder matches
PowerShell scripts parse
POSIX scripts parse
all markdown fences balanced
```

- [ ] **Step 2: Sync local Codex install**

Run:

```powershell
Set-Location -LiteralPath 'D:\AI\ChatGPT\systems-check'
.\scripts\sync.ps1
```

Expected:

```text
Synced system-check skill to C:\Users\dalib\.codex\skills\system-check\SKILL.md
Restart Codex so the skill list refreshes.
```

- [ ] **Step 3: Commit locally**

Run:

```powershell
git -c safe.directory=D:/AI/ChatGPT/systems-check status --short
git -c safe.directory=D:/AI/ChatGPT/systems-check add .
git -c safe.directory=D:/AI/ChatGPT/systems-check commit -m "feat: switch to manual sc targeting"
```

Expected: local commit succeeds. Do not push unless the user explicitly requests it and confirms the 2slowDD push warning.

## Self-Review Checklist

- Spec coverage: manual trigger, target resolution, sidecar default, override options, AGENTS replacement, uninstall/sync, docs, CI, verification, local install, and commit.
- Placeholder scan: no placeholder marker terms should appear outside verification commands.
- Safety: no automatic complex-skill hook remains.
