# Changelog

All notable changes to this project are documented here.

This project follows the spirit of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and uses semantic versioning.

## [0.1.0] - 2026-04-16

### Added

- Initial `system-check` Codex skill.
- Light preflight requirement model for complex skills.
- Inline and sidecar manifest lookup order.
- Missing-manifest fallback that asks for local path or remote/source.
- Sidecar cache default for discovered manifests.
- Secret-safe environment variable checks.
- Windows and POSIX install scripts.
- Claude-specific Windows and POSIX install scripts.
- Example `## System Check Requirements` manifest.
- README, security policy, contribution guide, and local security review notes.
- EditorConfig, Git attributes, and code of conduct.
- GitHub issue and pull request templates.
- README badge strip for CI, Claude Code Skill, Codex Skill, license, and version.
- GitHub Actions CI workflow for package validation.
- Manual `sc-*` targeting as the supported invocation model.
- Removal of automatic complex-skill preflight behavior.
- Sidecar cache as the default generated-manifest save target, with inline/no-save override choices.
- Uninstall and sync scripts for Codex and Claude on Windows and POSIX.
- Uninstall behavior that preserves cached manifests.
