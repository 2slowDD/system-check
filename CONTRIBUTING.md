# Contributing

Thanks for improving `systems-check`.

## Development Principles

- Keep the skill text clear and operational.
- Prefer light checks over live readiness probes.
- Preserve the default stop behavior when required items fail.
- Never expose environment variable values.
- Avoid adding network behavior unless it is explicitly user-approved in the skill instructions.
- Keep examples generic and free of real secrets or private paths.

## Local Review Checklist

Before submitting changes:

- Read `skill/SKILL.md` end to end.
- Confirm no secrets or tokens are present.
- Confirm examples use placeholders only.
- Confirm install scripts only copy the skill into the Codex skills directory.
- Confirm Markdown fences render correctly.
- Update `CHANGELOG.md` for user-visible changes.

## Commit Style

Use concise conventional-style commits when practical:

```text
feat: add manifest cache instructions
docs: clarify install steps
fix: tighten missing-manifest fallback
```
