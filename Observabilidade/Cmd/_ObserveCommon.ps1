# Shared helpers for Observe replay scripts.
# Dot-source from entry scripts. Do not run directly.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-ObserveRepoRoot {
    # Observabilidade/Cmd -> Observabilidade -> Projeto
    return (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
}

function Get-ObserveExePath {
    param([string]$Exe)
    if ($Exe -and (Test-Path -LiteralPath $Exe)) {
        return (Resolve-Path -LiteralPath $Exe).Path
    }
    $candidates = @(
        (Join-Path (Split-Path (Get-ObserveRepoRoot) -Parent) 'Projeto_Avaliacao.exe'),
        (Join-Path (Get-ObserveRepoRoot) 'Win32\Debug\Projeto_Avaliacao.exe'),
        (Join-Path (Get-ObserveRepoRoot) 'Projeto_Avaliacao.exe')
    )
    foreach ($c in $candidates) {
        if (Test-Path -LiteralPath $c) {
            return (Resolve-Path -LiteralPath $c).Path
        }
    }
    return $candidates[0]
}

function Get-ObserveLogsDir {
    param([string]$LogsDir, [string]$ExePath)
    if ($LogsDir -and (Test-Path -LiteralPath $LogsDir)) {
        return (Resolve-Path -LiteralPath $LogsDir).Path
    }
    if (-not $ExePath) {
        $ExePath = Get-ObserveExePath
    }
    $besideExe = Join-Path (Split-Path -Parent $ExePath) 'Logs'
    if (-not (Test-Path -LiteralPath $besideExe)) {
        New-Item -ItemType Directory -Path $besideExe -Force | Out-Null
    }
    return (Resolve-Path -LiteralPath $besideExe).Path
}

function Assert-ObserveScriptPermission {
    param([switch]$FixPolicy)

    $processPolicy = Get-ExecutionPolicy -Scope Process
    if ($processPolicy -in @('Bypass', 'Unrestricted', 'RemoteSigned', 'Undefined')) {
        # Process Bypass (Cursor) or permissive: ok.
        if ($processPolicy -ne 'Undefined') {
            return
        }
    }

    $effective = Get-ExecutionPolicy
    if ($effective -in @('Bypass', 'Unrestricted', 'RemoteSigned')) {
        return
    }

    $machine = Get-ExecutionPolicy -Scope MachinePolicy
    $userPol = Get-ExecutionPolicy -Scope UserPolicy
    $currentUser = Get-ExecutionPolicy -Scope CurrentUser
    $localMachine = Get-ExecutionPolicy -Scope LocalMachine

    if ($FixPolicy) {
        if ($machine -ne 'Undefined' -or $userPol -ne 'Undefined') {
            Write-Error @"
ExecutionPolicy bloqueada por GPO (MachinePolicy=$machine UserPolicy=$userPol).
Nao e possivel corrigir com -FixPolicy. Use:
  powershell -NoProfile -ExecutionPolicy Bypass -File <script.ps1>
"@
            exit 2
        }
        try {
            Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
            Write-Host "ExecutionPolicy CurrentUser ajustada para RemoteSigned."
            return
        }
        catch {
            Write-Error "Falha ao ajustar ExecutionPolicy: $($_.Exception.Message)"
            exit 2
        }
    }

    Write-Host @"
ERRO: ExecutionPolicy impede a execucao de scripts (.ps1).
  Efetiva=$effective Process=$processPolicy CurrentUser=$currentUser LocalMachine=$localMachine

Opcao 1 (recomendada no Cursor, sem mudar policy permanente):
  powershell -NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath"

Opcao 2 (permanente para o usuario atual):
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Opcao 3 (este script):
  ... -FixPolicy
"@ -ForegroundColor Yellow
    exit 2
}

function Get-ObserveLogFiles {
    param([string]$LogsDir)
    Get-ChildItem -LiteralPath $LogsDir -Filter 'observe-*.jsonl' -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending
}

function Resolve-ObserveLogTarget {
    param(
        [string]$Log,
        [string]$Name,
        [Nullable[int]]$Index,
        [string]$LogsDir
    )

    if ($Log) {
        if (-not (Test-Path -LiteralPath $Log)) {
            throw "Arquivo nao encontrado: $Log"
        }
        return (Resolve-Path -LiteralPath $Log).Path
    }
    if ($Name) {
        $path = Join-Path $LogsDir $Name
        if (-not (Test-Path -LiteralPath $path)) {
            throw "Log nao encontrado em Logs: $Name"
        }
        return (Resolve-Path -LiteralPath $path).Path
    }
    if ($Index -ne $null) {
        $files = @(Get-ObserveLogFiles -LogsDir $LogsDir)
        if ($Index -lt 1 -or $Index -gt $files.Count) {
            throw "Indice invalido: $Index (ha $($files.Count) arquivo(s))"
        }
        return $files[$Index - 1].FullName
    }
    throw "Informe -Log, -Name ou -Index"
}

function Write-ObserveResultJson {
    param(
        [bool]$Ok,
        [string]$Scenario = '',
        [int]$Steps = 0,
        [int]$FailedStep = -1,
        [string]$Message = '',
        [string]$LogFile = '',
        [int]$ExitCode = 0,
        [string]$ResultPath = ''
    )
    $obj = [ordered]@{
        ok         = $Ok
        scenario   = $Scenario
        steps      = $Steps
        failedStep = $FailedStep
        message    = $Message
        logFile    = $LogFile
        exitCode   = $ExitCode
    }
    $json = ($obj | ConvertTo-Json -Compress)
    Write-Output $json
    if ($ResultPath) {
        $dir = Split-Path -Parent $ResultPath
        if (-not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        Set-Content -LiteralPath $ResultPath -Value $json -Encoding UTF8
    }
}
