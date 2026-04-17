# System Check Requirements Example

Copy the fenced manifest block below into the target skill's `SKILL.md`, then customize the entries.

```markdown
## System Check Requirements
- required skill: system-check
- required skill: example-subskill
- required mcp: example_service | mcp__example_service
- required command: python
- optional env: EXAMPLE_API_KEY
- required project-root: <absolute path to EXAMPLE-PROJECT>
- required path: <absolute path to EXAMPLE-PROJECT>\scripts\check_deps.py
- note: Optional API checks should be skipped when EXAMPLE_API_KEY is missing
```

`required` is the default severity, aliases can be separated with `|`, and `note` entries are informational only.

Requirement types:

- `skill`: another skill needed by the workflow
- `mcp`: MCP/tool namespace needed in the current session
- `command`: local CLI command
- `env`: environment variable, value never printed
- `project-root`: required working root
- `path`: required helper script or file
- `note`: informational only
