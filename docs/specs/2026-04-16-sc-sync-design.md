# sc-sync Design

## Goal

Add `sc-sync` as a reserved `system-check` command that checks whether the local `systems-check` source repository is current with `origin/main` and, when safe, updates the installed skill for Codex or Claude.

## Behavior

- `sc-sync` is handled before normal `sc-<partial>` target suggestion logic.
- The command resolves the local source repository from the current Git repository, `SYSTEM_CHECK_REPO`, or common local clone paths.
- The command stops if the working tree is dirty, local commits are ahead of the remote, or the branch diverged.
- The command runs `git fetch origin` and updates only via `git pull --ff-only origin main`.
- After a successful fast-forward, it refreshes the host install with the existing sync script:
  - Codex: `scripts\sync.ps1` or `scripts/sync.sh`
  - Claude: `scripts\sync-claude.ps1` or `scripts/sync-claude.sh`

## Safety

`sc-sync` never pushes, force-pushes, rebases, resets, or deletes files. If a clean fast-forward is not possible, it reports the state and stops.

## Verification

The release verification script checks that README, changelog, and skill instructions document the new behavior and version.
