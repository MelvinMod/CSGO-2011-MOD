$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath 'C:\Program Files (x86)\Steam\steamapps\common\csgo legacy\migi\csgo\addons'
$out = New-Object System.Collections.Generic.List[string]

# 1) Player models missing .dx90.vtx
$out.Add("=== PLAYER MODELS: .mdl present but .dx90.vtx MISSING ===")
$mdls = Get-ChildItem -LiteralPath "p_cs15\models\player" -File -Filter "*.mdl"
foreach ($m in $mdls) {
    $dx = [System.IO.Path]::Combine($m.DirectoryName, $m.BaseName + ".dx90.vtx")
    $vt = [System.IO.Path]::Combine($m.DirectoryName, $m.BaseName + ".vtx")
    $vd = [System.IO.Path]::Combine($m.DirectoryName, $m.BaseName + ".vvd")
    $hasDx = Test-Path -LiteralPath $dx
    $hasVt = Test-Path -LiteralPath $vt
    $hasVd = Test-Path -LiteralPath $vd
    if (-not $hasDx) {
        $out.Add("$($m.Name) | vtx=$hasVt vvd=$hasVd dx90=$hasDx")
    }
}

$out.Add("")
$out.Add("=== MATERIALS referencing blood ===")
$mats = Get-ChildItem -LiteralPath "p_cs15\materials" -Recurse -File -Include "*.vmt" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'blood|headshot|impact' }
foreach ($m in $mats) { $out.Add($m.FullName) }

Set-Content -LiteralPath "_player_dump.txt" -Value $out -Encoding UTF8
