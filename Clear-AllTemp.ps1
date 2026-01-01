# Comprehensive cleaning script with a selection menu
# Some operations require administrator rights

Write-Host "=== Complete Cleaning Of Temporary Files ===`n" -ForegroundColor Cyan

function Show-Menu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Select An Action:" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  1. Clear the user's temporary files" -ForegroundColor Gray
    Write-Host "  2. Clear system temporary files (Admin)" -ForegroundColor Gray
    Write-Host "  3. Clear the Prefetch folder (Admin)" -ForegroundColor Gray
    Write-Host "  4. Empty the shopping cart" -ForegroundColor Gray
    Write-Host "  5. Clear the Windows Temp folder (Admin)" -ForegroundColor Gray
    Write-Host "  6. Clear the updates folder (Admin)" -ForegroundColor Gray
    Write-Host "  7. ALL TOGETHER (except the basket)" -ForegroundColor Yellow
    Write-Host "  0. Exit" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
}

do {
    Show-Menu
    $choice = Read-Host "`nEnter the action number (0-7)"
    
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
            Write-Host "`nStarting Prefetch cleanup..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-Prefetch.ps1 | iex
            Pause
        }
        "4" {
            Write-Host "`nStarting the trash cleanup..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-RecycleBin.ps1 | iex
            Pause
        }
        "5" {
            Write-Host "`nStarting Windows Temp cleanup..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-WindowsTemp.ps1 | iex
            Pause
        }
        "6" {
            Write-Host "`nStart cleaning the update folder..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-SoftwareDistribution.ps1 | iex
            Pause
        }
        "7" {
            Write-Host "`nSTARTING FULL PLEASURE..." -ForegroundColor Yellow -BackgroundColor DarkRed
            
            # Checking administrator rights
            $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            
            if (-not $isAdmin) {
                Write-Host "Administrator rights are required for complete cleaning!" -ForegroundColor Red
                Write-Host "Run PowerShell as an administrator" -ForegroundColor Yellow
                Pause
                break
            }
            
            # Sequential launch of all scripts
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-UserTemp.ps1 | iex
            Write-Host "`n" -NoNewline
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-SystemTemp.ps1 | iex
            Write-Host "`n" -NoNewline
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-Prefetch.ps1 | iex
            Write-Host "`n" -NoNewline
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-WindowsTemp.ps1 | iex
            Write-Host "`n" -NoNewline
            irm https://raw.githubusercontent.com/S1mvolxD/Windows-Temp-Cleaner/refs/heads/main/Clear-SoftwareDistribution.ps1 | iex
            
            Write-Host "`n=== FULL CLEANING IS COMPLETE ===" -ForegroundColor Green
            Write-Host "It is recommended to restart the computer" -ForegroundColor Yellow
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
