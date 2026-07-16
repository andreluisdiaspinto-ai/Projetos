<#
.SYNOPSIS
  Converte JSONL em scenario e executa replay no ERP (-replay).
#>
param(
    [string]$Log = '',
    [string]$Name = '',
    [Nullable[int]]$Index = $null,
    [string]$Exe = '',
    [string]$LogsDir = '',
    [int]$TimeoutSec = 180,
    [switch]$FixPolicy
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_ObserveCommon.ps1')
. (Join-Path $PSScriptRoot 'Convert-ObserveLog.ps1')
Assert-ObserveScriptPermission -FixPolicy:$FixPolicy

try {
    $exePath = Get-ObserveExePath -Exe $Exe
    if (-not (Test-Path -LiteralPath $exePath)) {
        throw "Executavel nao encontrado: $exePath"
    }
    $logs = Get-ObserveLogsDir -LogsDir $LogsDir -ExePath $exePath
    $logPath = Resolve-ObserveLogTarget -Log $Log -Name $Name -Index $Index -LogsDir $logs

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $scenarioPath = Join-Path $logs ("scenario-{0}.json" -f $stamp)
    $converted = Convert-ObserveLogToScenario -LogPath $logPath -OutPath $scenarioPath
    if ($converted.Steps -eq 0) {
        throw "Scenario sem steps (log vazio ou so Session*). Escolha outro arquivo com -Name ou -Index."
    }

    Write-Host "Log:      $logPath"
    Write-Host "Scenario: $scenarioPath ($($converted.Steps) steps)"
    Write-Host "Exe:      $exePath"

    $resultFile = Join-Path $logs 'ultimo-replay-result.json'
    if (Test-Path -LiteralPath $resultFile) {
        Remove-Item -LiteralPath $resultFile -Force
    }

    $argLine = '-observe -replay "{0}"' -f $scenarioPath
    $proc = Start-Process -FilePath $exePath -ArgumentList $argLine `
        -WorkingDirectory (Split-Path -Parent $exePath) `
        -PassThru

    $okWait = $proc.WaitForExit($TimeoutSec * 1000)
    if (-not $okWait) {
        try { $proc.Kill() } catch { }
        Write-ObserveResultJson -Ok $false -Scenario $scenarioPath -Steps $converted.Steps `
            -FailedStep -1 -Message "Timeout apos ${TimeoutSec}s" -LogFile $logPath `
            -ExitCode 2 -ResultPath (Join-Path $logs 'ultimo-replay-result-cli.json')
        exit 2
    }

    $exitCode = $proc.ExitCode
    $msg = ''
    $failed = -1
    $steps = $converted.Steps
    $ok = ($exitCode -eq 0)

    if (Test-Path -LiteralPath $resultFile) {
        try {
            $rr = Get-Content -LiteralPath $resultFile -Raw -Encoding UTF8 | ConvertFrom-Json
            $ok = [bool]$rr.ok
            if ($null -ne $rr.steps) { $steps = [int]$rr.steps }
            if ($null -ne $rr.failedStep) { $failed = [int]$rr.failedStep }
            if ($rr.message) { $msg = [string]$rr.message }
            if ($null -ne $rr.exitCode) { $exitCode = [int]$rr.exitCode }
        }
        catch {
            $msg = "Falha ao ler resultado: $($_.Exception.Message)"
            $ok = $false
            $exitCode = 1
        }
    }
    elseif (-not $ok) {
        $msg = "ERP encerrou com codigo $exitCode sem ultimo-replay-result.json"
    }

    Write-ObserveResultJson -Ok $ok -Scenario $scenarioPath -Steps $steps `
        -FailedStep $failed -Message $msg -LogFile $logPath -ExitCode $exitCode `
        -ResultPath (Join-Path $logs 'ultimo-replay-result-cli.json')

    if ($ok) { exit 0 } else { exit 1 }
}
catch {
    Write-ObserveResultJson -Ok $false -Message $_.Exception.Message -ExitCode 1
    exit 1
}
