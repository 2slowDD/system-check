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

// Derive current version from CHANGELOG so this file never needs updating on bumps
const changelogText = read('CHANGELOG.md');
const versionMatch = changelogText.match(/^## \[(\d+\.\d+\.\d+)\]/m);
if (!versionMatch) throw new Error('CHANGELOG.md has no version entry matching ## [x.y.z]');
const currentVersion = versionMatch[1];

const checks = [
  ['README.md', `Version ${currentVersion}`],
  ['README.md', 'system-check-sync'],
  ['README.md', 'Use absolute paths in manifests'],
  ['README.md', '<absolute path to SEO-AUDIT-ORIGINAL>'],
  [`CHANGELOG.md`, `## [${currentVersion}]`],
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
