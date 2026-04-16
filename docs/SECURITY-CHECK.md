# Local Security Check

Date: 2026-04-16

## Scope

Reviewed files prepared for the initial public repository:

- `skill/SKILL.md`
- `examples/system-check-requirements-example.md`
- `scripts/install.ps1`
- `scripts/install.sh`
- `scripts/install-claude.ps1`
- `scripts/install-claude.sh`
- `scripts/sync.ps1`
- `scripts/sync.sh`
- `scripts/sync-claude.ps1`
- `scripts/sync-claude.sh`
- `scripts/uninstall.ps1`
- `scripts/uninstall.sh`
- `scripts/uninstall-claude.ps1`
- `scripts/uninstall-claude.sh`
- `README.md`
- `CHANGELOG.md`
- `SECURITY.md`
- `CONTRIBUTING.md`
- `CODE_OF_CONDUCT.md`
- `LICENSE`
- `.gitignore`
- `.editorconfig`
- `.gitattributes`
- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`
- `.github/pull_request_template.md`
- `.github/workflows/ci.yml`

## Findings

- No secrets, tokens, private keys, or credentials are included.
- Environment variable examples use placeholder names only.
- The skill explicitly forbids printing environment variable values.
- The skill avoids network, GitHub, API, auth, crawl, install, and paid-service checks by default.
- Missing manifests fail closed and require user input before recovery.
- Remote source inspection requires user-provided or user-approved source.
- Local source inspection is preferred over remote source inspection.
- Discovered manifests are cached in a sidecar location by default.
- Bootstrap mode shows generated manifests before saving.
- Bootstrap mode does not silently edit skill files.
- `system-check` does not run automatically before complex skills.
- Manual `sc-*` targeting is required.
- Sidecar cache is the default generated-manifest save target.
- Inline saves require explicit user choice.
- The install scripts only copy `skill/SKILL.md` into the user's local Codex or Claude skills directory.
- The sync scripts only copy `skill/SKILL.md` into the user's local Codex or Claude skills directory.
- The uninstall scripts remove only the installed `system-check` skill directory.
- The uninstall scripts do not remove cached manifests.
- The install, sync, and uninstall scripts do not download dependencies, execute remote code, modify shell profiles, or contact remote systems.

## Residual Risk

- This is an instruction-based skill, so behavior depends on the host agent following the instructions.
- Remote source inspection, when approved by a user, may expose source URLs to the tools used for inspection.
- Installing the skill writes to the user's local Codex skills directory by design.

## Result

Security review passed for initial publication.
