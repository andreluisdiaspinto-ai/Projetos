<#
.SYNOPSIS
  Converte JSONL em scenario sem abrir o ERP (dry-run).
#>
param(
    [string]$Log = '',
    [string]$Name = '',
    [Nullable[int]]$Index = $null,
    [string]$Exe = '',
    [string]$LogsDir = '',
    [switch]$FixPolicy
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_ObserveCommon.ps1')
. (Join-Path $PSScriptRoot 'Convert-ObserveLog.ps1')
Assert-ObserveScriptPermission -FixPolicy:$FixPolicy

try {
    $exePath = Get-ObserveExePath -Exe $Exe
    $logs = Get-ObserveLogsDir -LogsDir $LogsDir -ExePath $exePath
    $logPath = Resolve-ObserveLogTarget -Log $Log -Name $Name -Index $Index -LogsDir $logs

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $scenarioPath = Join-Path $logs ("scenario-{0}.json" -f $stamp)
    $converted = Convert-ObserveLogToScenario -LogPath $logPath -OutPath $scenarioPath

    Write-Host "Dry-run OK"
    Write-Host "Log:      $logPath"
    Write-Host "Scenario: $scenarioPath"
    Write-Host "Steps:    $($converted.Steps)"
    $n = 0
    foreach ($s in $converted.Items) {
        $n++
        $extra = ''
        if ($s.op -eq 'Action') { $extra = "$($s.action)" }
        elseif ($s.op -eq 'Fill') { $extra = "$($s.control)=$($s.value)" }
        elseif ($s.op -eq 'AssertMessage') { $extra = $s.contains }
        elseif ($s.op -eq 'WaitForm' -or $s.op -eq 'CloseForm') { $extra = $s.form }
        Write-Host ("  {0,2}. {1,-14} {2}" -f $n, $s.op, $extra)
    }

    Write-ObserveResultJson -Ok $true -Scenario $scenarioPath -Steps $converted.Steps `
        -LogFile $logPath -ExitCode 0
    exit 0
}
catch {
    Write-ObserveResultJson -Ok $false -Message $_.Exception.Message -ExitCode 1
    exit 1
}
