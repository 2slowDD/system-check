# Security Policy

## Supported Versions

| Version | Supported |
| ------- | --------- |
| 0.1.x   | Yes       |

## Reporting A Vulnerability

Open a private advisory or contact the maintainer through the repository owner if private advisories are unavailable.

Please include:

- affected version or commit
- reproduction steps
- expected and actual behavior
- whether secrets, credentials, local files, or remote systems could be exposed

## Security Expectations

`system-check` must remain a light preflight gate. It should not:

- print environment variable values
- perform API calls by default
- perform auth probes by default
- crawl sites by default
- install packages by default
- write to remote systems by default
- mutate target skill files during normal preflight

Discovered manifests should be written to the sidecar cache by default. Inline skill edits should happen only during an explicit maintenance workflow requested by the user.
