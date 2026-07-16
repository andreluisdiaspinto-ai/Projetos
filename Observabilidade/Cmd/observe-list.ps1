<#
.SYNOPSIS
  Lista logs JSONL do Interaction Recorder (enumerados).
#>
param(
    [string]$LogsDir = '',
    [switch]$FixPolicy
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_ObserveCommon.ps1')
Assert-ObserveScriptPermission -FixPolicy:$FixPolicy

$exe = Get-ObserveExePath
$logs = Get-ObserveLogsDir -LogsDir $LogsDir -ExePath $exe
$files = @(Get-ObserveLogFiles -LogsDir $logs)

Write-Host "Logs disponiveis em $logs"
if ($files.Count -eq 0) {
    Write-Host "  (nenhum observe-*.jsonl encontrado)"
}
else {
    $n = 1
    foreach ($f in $files) {
        $kb = [math]::Round($f.Length / 1KB, 1)
        Write-Host ("  [{0}] {1}  ({2:yyyy-MM-dd HH:mm}, {3} KB)" -f $n, $f.Name, $f.LastWriteTime, $kb)
        $n++
    }
}

$list = @()
$i = 1
foreach ($f in $files) {
    $list += [ordered]@{
        n     = $i
        name  = $f.Name
        path  = $f.FullName
        mtime = $f.LastWriteTime.ToString('s')
        bytes = $f.Length
    }
    $i++
}

$json = ([ordered]@{
        ok    = $true
        count = $files.Count
        files = $list
    } | ConvertTo-Json -Compress -Depth 5)
Write-Output $json
exit 0
