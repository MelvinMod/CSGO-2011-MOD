$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath 'C:\Program Files (x86)\Steam\steamapps\common\csgo legacy\migi\csgo\addons'
$out = New-Object System.Collections.Generic.List[string]

# Search PCF files for 'headshot' system names and material references
$pcfs = Get-ChildItem -LiteralPath "p_cs15\particles" -Recurse -Filter "*.pcf"
foreach ($p in $pcfs) {
    $b = [System.IO.File]::ReadAllBytes($p.FullName)
    $sb = New-Object System.Text.StringBuilder
    $strings = New-Object System.Collections.Generic.List[string]
    foreach ($c in $b) {
        if ($c -ge 32 -and $c -lt 127) { [void]$sb.Append([char]$c) }
        else {
            if ($sb.Length -ge 4) { $strings.Add($sb.ToString()) }
            [void]$sb.Clear()
        }
    }
    $hits = $strings | Where-Object { $_ -match 'headshot|blood' } | Select-Object -Unique
    if ($hits) {
        $out.Add("== $($p.FullName)")
        foreach ($h in $hits) { $out.Add("   $h") }
    }
}
Set-Content -LiteralPath "_pcfscan.txt" -Value $out -Encoding UTF8
