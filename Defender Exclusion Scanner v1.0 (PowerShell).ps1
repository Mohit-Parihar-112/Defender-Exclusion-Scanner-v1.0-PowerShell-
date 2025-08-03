# ✨ Defender Exclusion Viewer with Animation and Suspicious Filter
function Show-AnimatedTitle {
    param ([string]$Text, [ConsoleColor]$Color = 'Cyan')

    Clear-Host
    foreach ($char in $Text.ToCharArray()) {
        Write-Host -NoNewline $char -ForegroundColor $Color
        Start-Sleep -Milliseconds 30
    }
    Write-Host "`n"
}

function Check-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "❌ Please run this script as Administrator!" -ForegroundColor Red
        exit
    }
}

# Suspicious keywords to flag
$suspiciousKeywords = @("cheat", "trainer", "crack", "hack", "temp", "mod", "bypass", "inject", "spoof")

function Show-Exclusions {
    $prefs = Get-MpPreference

    Write-Host "`n📁 Excluded Folders:" -ForegroundColor Cyan
    foreach ($path in $prefs.ExclusionPath) {
        Show-Entry $path
    }

    Write-Host "`n⚙️  Excluded Processes:" -ForegroundColor Yellow
    foreach ($proc in $prefs.ExclusionProcess) {
        Show-Entry $proc
    }

    Write-Host "`n📄 Excluded File Extensions:" -ForegroundColor Green
    foreach ($ext in $prefs.ExclusionExtension) {
        Show-Entry $ext
    }

    Write-Host "`n🌐 Excluded IP Addresses:" -ForegroundColor Magenta
    foreach ($ip in $prefs.ExclusionIpAddress) {
        Show-Entry $ip
    }
}

function Show-Entry {
    param ($item)

    $suspicious = $false
    foreach ($keyword in $suspiciousKeywords) {
        if ($item -match $keyword) {
            $suspicious = $true
            break
        }
    }

    if ($suspicious) {
        Write-Host "  ⚠️  $item" -ForegroundColor Magenta
    } else {
        Write-Host "  ✔️  $item" -ForegroundColor Gray
    }
}

# Run the Scanner
Check-Admin
Show-AnimatedTitle "🛡️  Defender Exclusion Scanner v1.0 🛡️" 'White'
Start-Sleep -Milliseconds 300
Write-Host "🔍 Scanning for exclusion entries..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1.5

Show-Exclusions

Write-Host "`n✅ Scan Complete." -ForegroundColor Green
