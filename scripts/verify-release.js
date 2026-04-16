const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');

function read(relativePath) {
  return fs.readFileSync(path.join(root, relativePath), 'utf8');
}

function assertIncludes(file, expected) {
  const content = read(file);
  if (!content.includes(expected)) {
    throw new Error(`${file} is missing: ${expected}`);
  }
}

const checks = [
  ['README.md', 'Version 0.1.5'],
  ['README.md', 'system-check-sync'],
  ['CHANGELOG.md', '## [0.1.5] - 2026-04-16'],
  ['skill/SKILL.md', '## Built-In Sync Command'],
  ['skill/SKILL.md', '`system-check-sync`'],
  ['skill/SKILL.md', 'git pull --ff-only'],
  ['skill/SKILL.md', 'scripts\\sync.ps1'],
  ['skill/SKILL.md', 'scripts\\sync-claude.ps1'],
];

for (const [file, expected] of checks) {
  assertIncludes(file, expected);
}

console.log('Release documentation checks passed.');
