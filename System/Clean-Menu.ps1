# Quick-Clean.ps1 (v1) - A very basic option.
# Start PowerShell.exe: "irm https://raw.githubusercontent.com/S1mvolxD/PowerShell-Scripts/refs/heads/main/System/Clean-Menu.ps1 | iex"
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { # Automatic restart on behalf of the administrator
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" # We run ourselves as an administrator
    exit
}

Clear-Host
Write-Host "======== Cleaning management menu. ========" -ForegroundColor Cyan
Write-Host "1. Clear the user's temporary files"
Write-Host "0. Exit"
Write-Host "===========================================" -ForegroundColor Cyan

$choice = Read-Host "Select an option (0-1): "

switch ($choice) {
    "0" {
        Write-Host "Exit..." -ForegroundColor Red
        exit
    }
    "1" {
        Write-Host "`nStarting the cleaning of the user's temporary files..." -ForegroundColor Green
        irm https://raw.githubusercontent.com/S1mvolxD/PowerShell-Scripts/refs/heads/main/System/Clear-UserTemp.ps1 | iex
        Pause
    }
    Default {
        Write-Host "Wrong choice!" -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}

