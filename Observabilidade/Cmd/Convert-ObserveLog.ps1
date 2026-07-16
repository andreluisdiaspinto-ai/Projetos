# Converte JSONL do Interaction Recorder em scenario.json

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Convert-ObserveLogToScenario {
    param(
        [Parameter(Mandatory = $true)][string]$LogPath,
        [Parameter(Mandatory = $true)][string]$OutPath
    )

    $steps = New-Object System.Collections.Generic.List[object]
    $formsWithEditAction = @{}
    $crudForms = @('TForm_Cliente', 'TForm_Produto', 'TForm_Venda')
    $navActions = @('ActClientes', 'ActProdutos', 'ActVendas')
    $activeCrud = $null

    function Add-Step([hashtable]$Step) {
        $steps.Add([pscustomobject]$Step) | Out-Null
    }

    function Normalize-Value([string]$Value) {
        if ($null -eq $Value) { return '' }
        $v = $Value.Trim()
        if ($v -match '^R\$\s*(.+)$') {
            return $Matches[1].Trim()
        }
        return $v
    }

    $lines = Get-Content -LiteralPath $LogPath -Encoding UTF8
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try {
            $ev = $line | ConvertFrom-Json
        }
        catch {
            continue
        }
        if (-not $ev.type) { continue }
        $type = [string]$ev.type

        switch ($type) {
            'UI.Action' {
                $actionName = [string]$ev.action
                # Ignora troca de menu enquanto um CRUD ja esta aberto (ruido).
                if ($activeCrud -and ($navActions -contains $actionName)) {
                    break
                }
                Add-Step @{
                    op      = 'Action'
                    form    = [string]$ev.form
                    action  = $actionName
                    control = [string]$ev.control
                }
                if ($actionName -in @('ActInserir', 'ActEditar') -and $ev.form) {
                    $formsWithEditAction[[string]$ev.form] = $true
                }
            }
            'UI.OpenForm' {
                $form = [string]$ev.form
                Add-Step @{
                    op        = 'WaitForm'
                    form      = $form
                    timeoutMs = 10000
                }
                if ($crudForms -contains $form) {
                    $activeCrud = $form
                }
            }
            'UI.Fill' {
                $form = [string]$ev.form
                if ($crudForms -contains $form -and -not $formsWithEditAction.ContainsKey($form)) {
                    Add-Step @{
                        op      = 'Action'
                        form    = $form
                        action  = 'ActInserir'
                        control = 'BtnInserir'
                    }
                    $formsWithEditAction[$form] = $true
                }
                Add-Step @{
                    op      = 'Fill'
                    form    = $form
                    control = [string]$ev.control
                    value   = (Normalize-Value ([string]$ev.new))
                }
            }
            'UI.Message' {
                $kind = [string]$ev.kind
                $text = [string]$ev.text
                if ($text -match 'sair do sistema') { break }
                if ($kind -eq 'info' -or $text -match 'sucesso') {
                    # Garante ActGravar antes do assert se o log so tiver Post/Message.
                    if ($activeCrud) {
                        $hasGravar = $false
                        foreach ($s in $steps) {
                            if ($s.op -eq 'Action' -and $s.action -eq 'ActGravar' -and $s.form -eq $activeCrud) {
                                $hasGravar = $true
                                break
                            }
                        }
                        if (-not $hasGravar) {
                            Add-Step @{
                                op      = 'Action'
                                form    = $activeCrud
                                action  = 'ActGravar'
                                control = 'BtnGravar'
                            }
                        }
                    }
                    Add-Step @{
                        op        = 'AssertMessage'
                        contains  = $text
                        timeoutMs = 10000
                    }
                }
            }
            'UI.CloseForm' {
                $form = [string]$ev.form
                if ($form -and $form -ne 'TForm_Principal') {
                    # So fecha forms que de fato entraram no scenario.
                    $opened = $false
                    foreach ($s in $steps) {
                        if ($s.op -eq 'WaitForm' -and $s.form -eq $form) {
                            $opened = $true
                            break
                        }
                    }
                    if ($opened) {
                        Add-Step @{
                            op   = 'CloseForm'
                            form = $form
                        }
                    }
                }
                if ($form -eq $activeCrud) {
                    $activeCrud = $null
                }
            }
        }
    }

    # Remove LoginOk (nao e action de UI reproduzivel da mesma forma)
    $filtered = @($steps | Where-Object {
            -not ($_.op -eq 'Action' -and $_.action -eq 'LoginOk')
        })

    $scenario = [ordered]@{
        name      = ('Replay from {0}' -f (Split-Path -Leaf $LogPath))
        sourceLog = $LogPath
        steps     = $filtered
    }

    $dir = Split-Path -Parent $OutPath
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $json = $scenario | ConvertTo-Json -Depth 8
    Set-Content -LiteralPath $OutPath -Value $json -Encoding UTF8

    return [pscustomobject]@{
        Path  = $OutPath
        Steps = $filtered.Count
        Items = $filtered
    }
}
