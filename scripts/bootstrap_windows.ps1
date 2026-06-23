#requires -Version 5.1

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-WarnMessage {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-ErrorMessage {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Find-VSCodeExecutable {
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\Code.exe'),
        (Join-Path $env:ProgramFiles 'Microsoft VS Code\Code.exe')
    )

    if (${env:ProgramFiles(x86)}) {
        $candidates += Join-Path ${env:ProgramFiles(x86)} 'Microsoft VS Code\Code.exe'
    }

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }
    return $null
}

function Get-WslDistributionLines {
    $rawOutput = & wsl.exe --list --verbose 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-WarnMessage "WSL kurulu fakat henüz kullanılabilir bir dağıtım listelenemedi."
        return @()
    }

    return @($rawOutput | ForEach-Object { ("$_" -replace "`0", '').Trim() } | Where-Object { $_ })
}

function Main {
    $issues = [System.Collections.Generic.List[string]]::new()

    Write-Info 'Windows tarafındaki WSL ve VS Code ön koşulları kontrol ediliyor.'

    $wslCommand = Get-Command wsl.exe -ErrorAction SilentlyContinue
    if (-not $wslCommand) {
        Write-ErrorMessage 'WSL bulunamadı.'
        $issues.Add('WSL eksik')
        Write-WarnMessage "Yönetici PowerShell'de 'wsl --install -d Ubuntu' çalıştırın, Windows'u yeniden başlatın ve Ubuntu ilk kurulumunu tamamlayın."
    }
    else {
        Write-Success "WSL komutu bulundu: $($wslCommand.Source)"
        try {
            $distributionLines = Get-WslDistributionLines
            $ubuntuLines = @($distributionLines | Where-Object { $_ -match '(?i)\bUbuntu(?:-|\s|$)' })

            if ($ubuntuLines.Count -eq 0) {
                Write-ErrorMessage 'Kurulu bir Ubuntu WSL dağıtımı bulunamadı.'
                $issues.Add('Ubuntu dağıtımı eksik')
                Write-WarnMessage "Kurulum için 'wsl --install -d Ubuntu' komutunu kullanın."
            }
            else {
                Write-Success "Ubuntu dağıtımı bulundu: $($ubuntuLines -join '; ')"
                $ubuntuWsl2Lines = @($ubuntuLines | Where-Object { $_ -match '\s+2\s*$' })
                if ($ubuntuWsl2Lines.Count -eq 0) {
                    Write-ErrorMessage 'Ubuntu dağıtımı WSL 2 olarak görünmüyor.'
                    $issues.Add('Ubuntu WSL sürümü 2 değil')
                    Write-WarnMessage "Dağıtım adını 'wsl -l -v' ile bulun ve sonra 'wsl --set-version <DAGITIM_ADI> 2' çalıştırın."
                }
                else {
                    Write-Success 'Ubuntu dağıtımı WSL 2 kullanıyor.'
                }
            }
        }
        catch {
            Write-ErrorMessage $_.Exception.Message
            $issues.Add('WSL dağıtım bilgisi okunamadı')
        }
    }

    $codeCommand = Get-Command code -ErrorAction SilentlyContinue
    $codeExecutable = Find-VSCodeExecutable

    if ($codeExecutable) {
        Write-Success "VS Code bulundu: $codeExecutable"
    }
    elseif ($codeCommand) {
        Write-Success "VS Code 'code' komutu üzerinden bulundu: $($codeCommand.Source)"
    }
    else {
        Write-ErrorMessage 'VS Code kurulumu bulunamadı.'
        $issues.Add('VS Code eksik')
        Write-WarnMessage 'VS Code uygulamasını kurarken "Add to PATH" seçeneğini etkinleştirin.'
    }

    if ($codeCommand) {
        Write-Success "'code' komutu PATH üzerinde erişilebilir: $($codeCommand.Source)"
        Write-Info "WSL eklentisi gerekirse şu komutla kurulabilir: code --install-extension ms-vscode-remote.remote-wsl"
    }
    else {
        Write-ErrorMessage "'code' komutu PATH üzerinde bulunamadı."
        $issues.Add('code komutu eksik')
        Write-WarnMessage 'VS Code kurulumunu PATH seçeneğiyle onarın ve PowerShell penceresini yeniden açın.'
    }

    if ($issues.Count -gt 0) {
        Write-ErrorMessage "Kontrol başarısız: $($issues -join ', ')"
        Write-WarnMessage 'Bu script hiçbir dağıtımı silmedi, sıfırlamadı veya sistem ayarını değiştirmedi.'
        exit 1
    }

    Write-Success 'Windows ön koşulları hazır.'
    Write-Info "Şimdi Ubuntu'yu açın, repoya girin ve './setup.sh' çalıştırın."
}

Main
