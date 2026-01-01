# Clearing the Prefetch folder
# RUN AS AN ADMINISTRATOR IS REQUIRED

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator rights!" -ForegroundColor Red
    Write-Host "Run PowerShell as an administrator" -ForegroundColor Yellow
    exit 1
} # Checking administrator rights

Write-Host "=== Clearing the Prefetch folder ===" -ForegroundColor Cyan

$prefetchPath = "C:\Windows\Prefetch"
$backupPath = "$env:TEMP\PrefetchBackup"

if (Test-Path $prefetchPath) {
    Write-Host "Creating a backup copy..." -ForegroundColor Yellow
    # Creating a backup in case of problems
    if (Test-Path $backupPath) {
        Remove-Item $backupPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    Copy-Item -Path "$prefetchPath\*" -Destination $backupPath -Recurse -ErrorAction SilentlyContinue
    
    Write-Host "I'm clearing the Prefetch folder..." -ForegroundColor Yellow
    
    $files = Get-ChildItem -Path $prefetchPath -Filter "*.pf" -ErrorAction SilentlyContinue
    $fileCount = $files.Count
    $totalSize = ($files | Measure-Object -Property Length -Sum).Sum
    
    foreach ($file in $files) {
        try {
            Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "  Couldn't delete: $($file.Name)" -ForegroundColor Red
        }
    }
    
    # Deleting the layout.ini file
    $layoutFile = "$prefetchPath\layout.ini"
    if (Test-Path $layoutFile) {
        Remove-Item $layoutFile -Force -ErrorAction SilentlyContinue
    }
    
    $sizeInMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "`nResult:" -ForegroundColor Green
    Write-Host "Deleted files: $fileCount" -ForegroundColor Green
    Write-Host "Seats have been vacated: $sizeInMB MB" -ForegroundColor Green
    
    Write-Host "`nWARNING: Prefetch cleaning may slow down program startup the first time it is run after cleaning" -ForegroundColor Yellow
} else {
    Write-Host "The Prefetch folder was not found!" -ForegroundColor Red
}

Write-Host "`n=== Done ! ===" -ForegroundColor Cyan