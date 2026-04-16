$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Source = Join-Path $RepoRoot 'skill\SKILL.md'
$TargetDir = Join-Path $env:USERPROFILE '.codex\skills\system-check'
$Target = Join-Path $TargetDir 'SKILL.md'

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Source skill not found: $Source"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Copy-Item -LiteralPath $Source -Destination $Target -Force

Write-Output "Synced system-check skill to $Target"
Write-Output "Restart Codex so the skill list refreshes."
