# Bootstrap Manifest Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade `system-check` so missing manifests can be generated from local skill source, reviewed, saved by user choice, and immediately used for a rerun check.

**Architecture:** This is an instruction-skill upgrade, not a runtime library. Update the installable `skill/SKILL.md` as the source of truth, mirror it to the installed Codex skill after verification, and document the new bootstrap mode in README, changelog, and security notes.

**Tech Stack:** Markdown-based Codex/Claude skill instructions, PowerShell verification, local file copy installer behavior.

---

## File Structure

- Modify: `D:\AI\ChatGPT\systems-check\skill\SKILL.md`
  - Adds the bootstrap manifest workflow, inference rules, save choices, and safety rules.
- Modify: `C:\Users\dalib\.codex\skills\system-check\SKILL.md`
  - Installed local copy, updated from `skill\SKILL.md` after package verification.
- Modify: `D:\AI\ChatGPT\systems-check\README.md`
  - Documents automated manifest bootstrap and save choices.
- Modify: `D:\AI\ChatGPT\systems-check\CHANGELOG.md`
  - Records the bootstrap-mode enhancement.
- Modify: `D:\AI\ChatGPT\systems-check\docs\SECURITY-CHECK.md`
  - Adds security review notes for bootstrap behavior.

### Task 1: Update The Skill Source

**Files:**
- Modify: `D:\AI\ChatGPT\systems-check\skill\SKILL.md`

- [ ] **Step 1: Add bootstrap mode after `Requirement Lookup Order`**

Use `apply_patch` to add:

```markdown
## Bootstrap Missing Manifests

When a complex skill has no inline or cached manifest, enter bootstrap mode before asking the user to proceed.

Bootstrap mode:

1. Treat the missing manifest as a failed required item.
2. Inspect the target skill's local `SKILL.md` when available.
3. If local source is unavailable or insufficient, ask for a local path or GitHub/source URL.
4. Search the available source for dependency signals.
5. Generate a draft `## System Check Requirements` manifest.
6. Show the draft manifest to the user.
7. Ask where to save it:
   - `1. Sidecar cache`
   - `2. Inline skill file`
   - `3. Do not save`
8. Save only after the user chooses a save target.
9. Rerun `system-check` from the saved manifest.

If the user chooses not to save, stop before executing the target complex skill unless the user explicitly approves proceeding without a manifest.
```

- [ ] **Step 2: Add inference rules after `Light Check Types`**

Use `apply_patch` to add:

```markdown
## Manifest Inference Rules

When generating a draft manifest, prefer conservative, auditable inference:

- Add `required command` when a command is clearly necessary to run the skill.
- Add `required path` when a script or file is directly required by the skill.
- Add `required project-root` when instructions name a fixed working root.
- Add `required skill` when the skill explicitly invokes another skill as part of its normal workflow.
- Add `optional mcp` when an MCP improves the workflow but the skill describes a fallback.
- Add `required mcp` only when the workflow cannot run without that MCP.
- Add `optional env` for optional integrations or API enhancements.
- Add `required env` only when the skill cannot run without that variable.
- Add `note` for conditional behavior, fallback rules, or skip instructions.

Do not infer secrets or write secret values. Environment entries must name variables only.

Draft entries may include short confidence comments:

```markdown
- required command: python # high confidence: setup command uses python
- optional env: FIRECRAWL_API_KEY # medium confidence: optional Firecrawl integration
```
```

- [ ] **Step 3: Replace missing-manifest procedure steps**

Update the `Procedure` section so missing manifests bootstrap automatically:

```markdown
3. If no manifest exists, print the missing-manifest checklist and enter bootstrap mode.
4. Inspect the target skill's local `SKILL.md` first when available.
5. If local source is unavailable or insufficient, ask for the target skill's local path or GitHub remote/source, then stop until the user responds.
6. If the user provides a local path, inspect that local source first. If the user provides a remote/source URL, inspect it only after following current web/GitHub routing and approval rules.
7. Search source material for `Requirements`, `Dependencies`, `MCP`, `MCP integrations`, `Extensions`, `Tools`, `Environment variables`, `API keys`, `Setup`, `Install`, `Prerequisites`, `Subagents`, `Scripts`, `Project root`, `Commands`, `Auth`, command snippets, helper script paths, and referenced skill names.
8. Generate and show a draft manifest with confidence comments where helpful.
9. Ask where to save it: `1. Sidecar cache`, `2. Inline skill file`, or `3. Do not save`.
10. Save only after the user chooses a save target.
11. Rerun the light checklist from the saved manifest.
12. If all required items pass, print `System check: all green - proceeding.` and continue.
13. If any required item fails, list all results, print each failed required item, ask `Proceed or stop?`, and stop unless the user clearly says proceed.
```

- [ ] **Step 4: Add bootstrap output example**

Add this under `Required Output Format`:

```text
Bootstrap draft:

System check: <skill-name>

[fail] required manifest: no System Check Requirements section or sidecar manifest found

This requirement failed - manifest missing.

Generated manifest draft from local skill source.
Review before saving:

<draft manifest>

Save where?
1. Sidecar cache
2. Inline skill file
3. Do not save
```

- [ ] **Step 5: Tighten safety rules**

Ensure `Safety Rules` includes:

```markdown
- Never silently edit a skill file.
- Ask before remote or GitHub source inspection.
- Do not run expensive checks while generating a draft manifest.
- Do not execute the target skill until the manifest is saved and passes, or the user explicitly approves proceeding.
```

### Task 2: Update Documentation

**Files:**
- Modify: `D:\AI\ChatGPT\systems-check\README.md`
- Modify: `D:\AI\ChatGPT\systems-check\CHANGELOG.md`
- Modify: `D:\AI\ChatGPT\systems-check\docs\SECURITY-CHECK.md`

- [ ] **Step 1: Add README bootstrap section**

Add after `Manifest Format`:

```markdown
## Automatic Manifest Bootstrap

When a complex skill has no manifest, `system-check` can generate one from the local skill source.

The flow is:

1. Inspect local `SKILL.md` when available.
2. Infer a draft manifest from dependency signals.
3. Show the draft for review.
4. Ask where to save it:
   - `1. Sidecar cache`
   - `2. Inline skill file`
   - `3. Do not save`
5. Rerun the system check from the saved manifest.

Remote or GitHub source inspection only happens after the user provides or approves the source.
```

- [ ] **Step 2: Update changelog**

Add under `0.1.0`:

```markdown
- Bootstrap mode for generating missing manifests from local skill source.
- User-reviewed save choices for sidecar cache, inline skill file, or no save.
- Conservative inference rules with optional confidence comments.
```

- [ ] **Step 3: Update security notes**

Add to `docs\SECURITY-CHECK.md` findings:

```markdown
- Bootstrap mode shows generated manifests before saving.
- Bootstrap mode does not silently edit skill files.
- Local source inspection is preferred over remote source inspection.
- Remote source inspection remains user-provided or user-approved only.
```

### Task 3: Verify Package And Installed Copy

**Files:**
- Modify: `C:\Users\dalib\.codex\skills\system-check\SKILL.md`

- [ ] **Step 1: Run package verification**

Run:

```powershell
Set-Location -LiteralPath 'D:\AI\ChatGPT\systems-check'
$files = Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notmatch '\\.git\\' }
Select-String -Path $files.FullName -Pattern '<security-pattern-set>'
Select-String -Path $files.FullName -Pattern '<placeholder-pattern-set>'
$null=[scriptblock]::Create((Get-Content -LiteralPath '.\scripts\install.ps1' -Raw))
$null=[scriptblock]::Create((Get-Content -LiteralPath '.\scripts\install-claude.ps1' -Raw))
$fence = ([string][char]96) * 3
$bad = Get-ChildItem -Recurse -Filter *.md | Where-Object { ((Get-Content -LiteralPath $_.FullName -Raw).Split($fence).Count - 1) % 2 -ne 0 }
if ($bad) { $bad.FullName } else { 'all markdown fences balanced' }
```

Expected:

```text
no security pattern matches
no placeholder matches
PowerShell parsers complete without errors
all markdown fences balanced
```

- [ ] **Step 2: Verify POSIX installer syntax**

Run:

```shell
cd "/d/AI/ChatGPT/systems-check" && sh -n scripts/install.sh && sh -n scripts/install-claude.sh && echo "shell scripts parse ok"
```

Expected:

```text
shell scripts parse ok
```

- [ ] **Step 3: Install updated Codex skill locally**

Run:

```powershell
Set-Location -LiteralPath 'D:\AI\ChatGPT\systems-check'
.\scripts\install.ps1
```

Expected:

```text
Installed system-check skill to C:\Users\dalib\.codex\skills\system-check\SKILL.md
Restart Codex so the skill list refreshes.
```

### Task 4: Commit Locally

**Files:**
- Commit all modified package files.

- [ ] **Step 1: Review git diff**

Run:

```powershell
Set-Location -LiteralPath 'D:\AI\ChatGPT\systems-check'
git -c safe.directory=D:/AI/ChatGPT/systems-check diff --stat
git -c safe.directory=D:/AI/ChatGPT/systems-check diff -- skill/SKILL.md README.md CHANGELOG.md docs/SECURITY-CHECK.md
```

Expected: diff only covers bootstrap manifest behavior and related docs.

- [ ] **Step 2: Commit changes**

Run:

```powershell
git -c safe.directory=D:/AI/ChatGPT/systems-check add skill/SKILL.md README.md CHANGELOG.md docs/SECURITY-CHECK.md docs/specs/2026-04-16-bootstrap-manifest-design.md docs/plans/2026-04-16-bootstrap-manifest.md
git -c safe.directory=D:/AI/ChatGPT/systems-check commit -m "feat: add manifest bootstrap workflow"
```

Expected: commit succeeds locally. Do not push unless the user explicitly requests it and confirms the 2slowDD push warning.

## Self-Review Checklist

- Spec coverage: tasks cover bootstrap flow, local-first inspection, remote approval, inference rules, confidence comments, save choices, rerun check, docs, security notes, local install, and local commit.
- Placeholder scan: no placeholder marker terms should appear outside the verification command.
- Type consistency: requirement names remain `skill`, `mcp`, `command`, `path`, `project-root`, `env`, and `note`.
