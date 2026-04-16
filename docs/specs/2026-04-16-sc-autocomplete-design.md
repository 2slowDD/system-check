# sc Autocomplete Design

## Goal

Add a portable autocomplete helper for `system-check` invocations so users can send `sc-` or `sc-<partial>` and receive matching skill targets before a check runs.

## Scope

The feature provides post-send assistant autocomplete inside the AI chat flow. It does not implement native typeahead while the user is still typing because that requires host client support from Codex, Claude, or another AI client.

## Behavior

- `sc-` lists available skills from the current session inventory, grouped by source when known.
- `sc-<partial>` matches the suffix against skill names using the same normalization model as target resolution.
- One clear match asks for confirmation before running.
- Multiple matches produce a numbered list.
- No matches fall back to the existing missing-target flow.
- Codex fallback scans may check `~/.codex/skills`, `~/.codex/superpowers/skills`, and `~/.agents/skills`.
- Claude fallback scans should prefer the loaded Claude skill inventory, then known local Claude roots when available.

## Safety

Autocomplete requests never run checks automatically. The user must choose or confirm a target before `system-check` proceeds.

