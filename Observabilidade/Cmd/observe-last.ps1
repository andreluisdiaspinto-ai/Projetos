<#
.SYNOPSIS
  Reproduz o ultimo log apontado por Logs\ultimo-observe.txt
#>
param(
    [string]$Exe = '',
    [string]$LogsDir = '',
    [int]$TimeoutSec = 180,
    [switch]$FixPolicy
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_ObserveCommon.ps1')
Assert-ObserveScriptPermission -FixPolicy:$FixPolicy

$exePath = Get-ObserveExePath -Exe $Exe
$logs = Get-ObserveLogsDir -LogsDir $LogsDir -ExePath $exePath
$pointer = Join-Path $logs 'ultimo-observe.txt'
if (-not (Test-Path -LiteralPath $pointer)) {
    Write-ObserveResultJson -Ok $false -Message "Arquivo nao encontrado: $pointer" -ExitCode 1
    exit 1
}
$logPath = (Get-Content -LiteralPath $pointer -TotalCount 1 -Encoding UTF8).Trim()
if (-not (Test-Path -LiteralPath $logPath)) {
    Write-ObserveResultJson -Ok $false -Message "ultimo-observe aponta para arquivo inexistente: $logPath" -ExitCode 1
    exit 1
}

& (Join-Path $PSScriptRoot 'observe-replay.ps1') -Log $logPath -Exe $exePath -TimeoutSec $TimeoutSec -FixPolicy:$FixPolicy
exit $LASTEXITCODE
