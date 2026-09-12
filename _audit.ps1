$ErrorActionPreference = 'SilentlyContinue'
$out = @()

$src = Resolve-Path '.\cstrike15_custom\cstrike15'
$dst = Resolve-Path '.\p_cs15'

function Compare-Trees($aRoot, $bRoot, $title) {
    $lines = @()
    $lines += "=== $title ==="
    $aFiles = Get-ChildItem -Path $aRoot -Recurse -File
    foreach ($f in $aFiles) {
        $rel = $f.FullName.Substring($aRoot.Length + 1)
        # пропускаем props и maps (запрещено пользователем)
        if ($rel -match '(^|\\)props(\\|$)') { continue }
        if ($rel -match '^particles\\maps\\') { continue }
        $bPath = Join-Path $bRoot $rel
        if (-not (Test-Path -LiteralPath $bPath)) {
            $lines += "MISSING: $rel"
        }
    }
    if ($lines.Count -eq 1) { $lines += "(всё на месте)" }
    return $lines
}

$out += Compare-Trees "$src\sound" "$dst\sound" "SOUND: чего нет в p_cs15"
$out += ""
$out += Compare-Trees "$src\particles" "$dst\particles" "PARTICLES: чего нет в p_cs15"
$out += ""
$out += Compare-Trees "$src\models" "$dst\models" "MODELS: чего нет в p_cs15 (без props)"
$out += ""
$out += Compare-Trees "$src\materials" "$dst\materials" "MATERIALS: чего нет в p_cs15 (без props)"
$out += ""
$out += Compare-Trees "$src\scripts" "$dst\scripts" "SCRIPTS: чего нет в p_cs15"
$out += ""
$out += Compare-Trees "$src\resource" "$dst\resource" "RESOURCE: чего нет в p_cs15"

$out | Out-File -FilePath '.\_audit.txt' -Encoding UTF8
Write-Output "done"
