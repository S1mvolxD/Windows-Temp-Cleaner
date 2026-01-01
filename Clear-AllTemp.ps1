# Clear-AllTemp.ps1 (v1.8)
# Start PowerShell.exe: "irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-AllTemp.ps1 | iex"
function Show-Menu {
    Clear-Host
    Write-Host "=== Cleaning management menu. ===`n" -ForegroundColor Cyan
    Write-Host "  1. Clear the user's temporary files" -ForegroundColor Gray
    Write-Host "  2. Clear system temporary files (Admin)" -ForegroundColor Gray
    Write-Host "  3. Clear the Basket" -ForegroundColor Gray
    Write-Host "  0. Exit" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
}

do {
    Show-Menu
    $choice = Read-Host "`nEnter the action number (0-3)"

    switch ($choice) {
        "1" {
            Write-Host "`nStarting the cleaning of the user's temporary files..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-UserTemp.ps1 | iex
            Pause
        }
        "2" {
            Write-Host "`nStarting the cleaning of system temporary files..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-SystemTemp.ps1 | iex
            Pause
        }
        "3" {
            Write-Host "`nStarting the trash cleanup..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-RecycleBin.ps1 | iex
            Pause
        }
        "0" {
            Write-Host "`nExit..." -ForegroundColor Gray
            exit
        }
        default {
            Write-Host "`nIncorrect choice! Try again." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($choice -ne "0")


