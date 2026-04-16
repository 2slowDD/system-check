$ErrorActionPreference = 'Stop'

$TargetDir = Join-Path $env:USERPROFILE '.codex\skills\system-check'

if (Test-Path -LiteralPath $TargetDir) {
    Remove-Item -LiteralPath $TargetDir -Recurse -Force
    Write-Output "Removed system-check skill from $TargetDir"
} else {
    Write-Output "system-check skill is not installed at $TargetDir"
}

Write-Output "Cached manifests were not removed."
