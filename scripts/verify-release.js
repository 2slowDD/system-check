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

function assertExcludes(file, unexpected) {
  const content = read(file);
  if (content.includes(unexpected)) {
    throw new Error(`${file} still contains machine-specific text: ${unexpected}`);
  }
}

const checks = [
  ['README.md', 'Version 0.1.6'],
  ['README.md', 'system-check-sync'],
  ['README.md', 'Use absolute paths in manifests'],
  ['README.md', '<absolute path to SEO-AUDIT-ORIGINAL>'],
  ['CHANGELOG.md', '## [0.1.6] - 2026-04-17'],
  ['skill/SKILL.md', '## Built-In Sync Command'],
  ['skill/SKILL.md', '`system-check-sync`'],
  ['skill/SKILL.md', 'current working directory\'s `systems-check` child'],
  ['skill/SKILL.md', '%USERPROFILE%\\source\\systems-check'],
  ['skill/SKILL.md', 'Use absolute paths in manifests'],
  ['skill/SKILL.md', '<absolute path to SEO-AUDIT-ORIGINAL>'],
  ['skill/SKILL.md', 'git pull --ff-only'],
  ['skill/SKILL.md', 'scripts\\sync.ps1'],
  ['skill/SKILL.md', 'scripts\\sync-claude.ps1'],
  ['examples/system-check-requirements-example.md', '<absolute path to EXAMPLE-PROJECT>'],
  ['docs/specs/2026-04-16-bootstrap-manifest-design.md', '<absolute path to SEO-AUDIT-ORIGINAL>'],
];

for (const [file, expected] of checks) {
  assertIncludes(file, expected);
}

for (const file of [
  'README.md',
  'docs/specs/2026-04-16-bootstrap-manifest-design.md',
  'examples/system-check-requirements-example.md',
  'skill/SKILL.md',
]) {
  assertExcludes(file, 'D:\\AI\\SEO-AUDIT-ORIGINAL');
  assertExcludes(file, 'D:\\AI\\EXAMPLE-PROJECT');
  assertExcludes(file, 'D:\\AI\\ChatGPT\\systems-check');
}

console.log('Release documentation checks passed.');
