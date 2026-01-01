# Quick-Clean.ps1 (v1) - A very basic option.
# Start PowerShell.exe: "irm https://raw.githubusercontent.com/S1mvolxD/PowerShell-Scripts/refs/heads/main/System/Clean-Menu.ps1 | iex"
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { # Automatic restart on behalf of the administrator
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" # We run ourselves as an administrator
    exit
}

function Show-Menu {
    Clear-Host
    Write-Host "=== Cleaning management menu. ===`n" -ForegroundColor Cyan
    Write-Host "  1. Clear the user's temporary files" -ForegroundColor Gray
    Write-Host "  0. Exit" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
}

do {
    Show-Menu
    $choice = Read-Host "`nEnter the action number (0-1)"
    
    switch ($choice) {
        "1" {
            Write-Host "`nStarting the cleaning of the user's temporary files..." -ForegroundColor Green
            irm https://raw.githubusercontent.com/S1mvolxD/PowerShell-Scripts/refs/heads/main/System/Clear-UserTemp.ps1 | iex
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
