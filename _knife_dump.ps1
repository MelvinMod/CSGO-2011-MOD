$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath 'C:\Program Files (x86)\Steam\steamapps\common\csgo legacy\migi\csgo\addons'
$out = New-Object System.Collections.Generic.List[string]

function Dump-Strings([string]$path, [int]$minLen = 6) {
    if (-not (Test-Path -LiteralPath $path)) { $out.Add("MISSING: $path"); return }
    $b = [System.IO.File]::ReadAllBytes($path)
    $out.Add("FILE: $path")
    $sb = New-Object System.Text.StringBuilder
    $strings = New-Object System.Collections.Generic.List[string]
    foreach ($c in $b) {
        if ($c -ge 32 -and $c -lt 127) { [void]$sb.Append([char]$c) }
        else {
            if ($sb.Length -ge $minLen) { $strings.Add($sb.ToString()) }
            [void]$sb.Clear()
        }
    }
    $interesting = $strings | Where-Object { $_ -match 'models|weapons|\.vmt|\.vtf|\.mdl|\.ani|particle|pcf' } | Select-Object -Unique
    foreach ($s in $interesting) { $out.Add("  str: $s") }
    $out.Add("")
}

# knife models
Dump-Strings "p_cs15\models\weapons\v_knife.mdl"
Dump-Strings "p_cs15\models\weapons\v_knife_fix.mdl"
Dump-Strings "p_cs15\models\weapons\w_knife.mdl"

# arms used by knife
Dump-Strings "p_cs15\models\weapons\v_tm_professional_arms.mdl"

Set-Content -LiteralPath "_knife_dump.txt" -Value $out -Encoding UTF8
