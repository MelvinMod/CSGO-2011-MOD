$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath 'C:\Program Files (x86)\Steam\steamapps\common\csgo legacy\migi\csgo\addons'
$src = '.\cstrike15_custom\cstrike15'
$dst = '.\p_cs15'

# Копируем всё, что помечено MISSING в _audit.txt (кроме props*/maps), рекурсивно
$section = ''
$copied = 0; $skipped = 0
$missing = New-Object System.Collections.Generic.List[string]
foreach ($line in (Get-Content -LiteralPath '_audit.txt')) {
    if ($line -match '^===\s*(.+?)\s*===') { $section = $Matches[1]; continue }
    if ($line -notmatch '^MISSING:\s*(.+)$') { continue }
    $rel = $Matches[1]
    if ($rel -match '(^|\\)props[^\\]*(\\|$)') { $skipped++; continue }
    if ($rel -match '(^|\\)maps(\\|$)') { $skipped++; continue }
    $missing.Add($rel)
}

foreach ($rel in $missing) {
    $s = Join-Path $src $rel
    $d = Join-Path $dst $rel
    if (-not (Test-Path -LiteralPath $s)) { "NO-SRC: $rel"; continue }
    $dir = Split-Path -Parent $d
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    Copy-Item -LiteralPath $s -Destination $d -Force
    $copied++
}
"copied = $copied, skipped(props/maps) = $skipped"