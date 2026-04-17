$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Source = Join-Path $RepoRoot 'skill\SKILL.md'
$TargetDir = Join-Path $env:USERPROFILE '.claude\skills\system-check'
$Target = Join-Path $TargetDir 'SKILL.md'

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Source skill not found: $Source"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Copy-Item -LiteralPath $Source -Destination $Target -Force

Write-Output "Synced system-check skill to $Target"

# Ensure sc- trigger rule is present in CLAUDE.md (idempotent)
$ClaudeMd = Join-Path $env:USERPROFILE '.claude\CLAUDE.md'
$StartMarker = '<!-- sc-trigger:start -->'
$EndMarker = '<!-- sc-trigger:end -->'
$Rule = @"

$StartMarker
## system-check Trigger (sc-)
When the user sends a message matching ``sc-<target>`` (e.g. ``sc-seo``, ``sc-brainstorm``):
- Invoke the ``system-check`` skill with ``<target>`` as the target skill
- Do NOT treat it as a skill name or slash command directly
- If sent as ``sc-`` alone, invoke ``system-check`` and list available targets
$EndMarker
"@

if (-not (Test-Path -LiteralPath $ClaudeMd)) {
    New-Item -ItemType File -Force -Path $ClaudeMd | Out-Null
}

$existing = Get-Content -LiteralPath $ClaudeMd -Raw -ErrorAction SilentlyContinue
if ($null -eq $existing) { $existing = '' }

if (-not $existing.Contains($StartMarker)) {
    Add-Content -LiteralPath $ClaudeMd -Value $Rule
    Write-Output "Injected sc- trigger rule into $ClaudeMd"
} else {
    Write-Output "sc- trigger rule already present in $ClaudeMd"
}

Write-Output "Restart Claude so the skill list refreshes."
