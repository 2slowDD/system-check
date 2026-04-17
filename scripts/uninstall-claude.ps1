$ErrorActionPreference = 'Stop'

$TargetDir = Join-Path $env:USERPROFILE '.claude\skills\system-check'

if (Test-Path -LiteralPath $TargetDir) {
    Remove-Item -LiteralPath $TargetDir -Recurse -Force
    Write-Output "Removed system-check skill from $TargetDir"
} else {
    Write-Output "system-check skill is not installed at $TargetDir"
}

# Remove sc- trigger rule from CLAUDE.md
$ClaudeMd = Join-Path $env:USERPROFILE '.claude\CLAUDE.md'
$StartMarker = '<!-- sc-trigger:start -->'
$EndMarker = '<!-- sc-trigger:end -->'

if (Test-Path -LiteralPath $ClaudeMd) {
    $lines = Get-Content -LiteralPath $ClaudeMd
    $inBlock = $false
    $filtered = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        if ($line -eq $StartMarker) { $inBlock = $true; continue }
        if ($line -eq $EndMarker)   { $inBlock = $false; continue }
        if (-not $inBlock)          { $filtered.Add($line) }
    }
    if ($filtered.Count -ne $lines.Count) {
        Set-Content -LiteralPath $ClaudeMd -Value $filtered
        Write-Output "Removed sc- trigger rule from $ClaudeMd"
    } else {
        Write-Output "sc- trigger rule was not found in $ClaudeMd"
    }
}

Write-Output "Cached manifests were not removed."
