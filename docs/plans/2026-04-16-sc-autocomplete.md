# sc Autocomplete Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add post-send autocomplete behavior for exact `sc-` and partial `sc-<partial>` invocations.

**Architecture:** Keep the behavior in `skill/SKILL.md` because `system-check` is a documentation-driven skill. Document the host-client limitation in README and changelog, and bump the release version.

**Tech Stack:** Markdown skill documentation, repository README, changelog.

---

### Task 1: Add Failing Behavior Check

**Files:**
- Verify: `skill/SKILL.md`
- Verify: `README.md`

- [x] Run a script that checks for an autocomplete section, exact `sc-` handling, partial suffix handling, client-hook limitation text, and README documentation.
- [x] Confirm the script fails before editing because the feature is absent.

### Task 2: Add Skill Instructions

**Files:**
- Modify: `skill/SKILL.md`

- [x] Add `## Autocomplete / Partial Invocation`.
- [x] Define exact `sc-` behavior.
- [x] Define partial `sc-<partial>` behavior.
- [x] Add Codex and Claude fallback source guidance.
- [x] Update procedure and safety rules so autocomplete does not run checks automatically.

### Task 3: Update Release Docs

**Files:**
- Modify: `README.md`
- Modify: `CHANGELOG.md`

- [x] Bump the README badge and current release from `0.1.2` to `0.1.3`.
- [x] Add README autocomplete usage notes.
- [x] Add changelog entry for `0.1.3`.

### Task 4: Verify And Publish

**Files:**
- Verify all modified files.

- [x] Re-run the behavior check and confirm it passes.
- [x] Run repository validation.
- [x] Sync the installed Codex skill copy.
- [x] Commit locally.
- [ ] Ask for explicit 2slowDD push confirmation before pushing remotely.
