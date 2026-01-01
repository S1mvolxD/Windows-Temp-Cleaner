# Cleaning the C:\Windows\Temp folder
# RUN AS AN ADMINISTRATOR IS REQUIRED

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator rights!" -ForegroundColor Red
    Write-Host "Run PowerShell as an administrator" -ForegroundColor Yellow
    exit 1
} # Checking administrator rights

Write-Host "=== Clearing the Windows Temp folder ===" -ForegroundColor Cyan

$windowsTempPath = "C:\Windows\Temp"
$backupPath = "$env:TEMP\WindowsTempBackup"

if (Test-Path $windowsTempPath) {
    Write-Host "I'm creating a backup of important files..." -ForegroundColor Yellow
    
    # Creating a backup folder
    if (Test-Path $backupPath) {
        Remove-Item $backupPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    
    # We only copy files that may be important (such as installation logs)
    Get-ChildItem -Path $windowsTempPath -Filter "*install*" -ErrorAction SilentlyContinue | 
        Copy-Item -Destination $backupPath -ErrorAction SilentlyContinue
    
    Write-Host "I'm clearing the Windows Temp folder..." -ForegroundColor Yellow
    
    $files = Get-ChildItem -Path $windowsTempPath -Recurse -ErrorAction SilentlyContinue
    $fileCount = $files.Count
    $totalSize = 0
    $deletedCount = 0
    
    foreach ($file in $files) {
        try {
            # Do not delete the Temp folder itself, only its contents
            if ($file.FullName -ne $windowsTempPath) {
                Remove-Item $file.FullName -Recurse -Force -ErrorAction SilentlyContinue
                $deletedCount++
                $totalSize += $file.Length
            }
        } catch {
            Write-Host "  Occupied: $($file.Name)" -ForegroundColor Gray
        }
    }
    
    $sizeInMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "`nResult:" -ForegroundColor Green
    Write-Host "Deleted files: $deletedCount из $fileCount" -ForegroundColor Green
    Write-Host "Seats have been vacated: $sizeInMB MB" -ForegroundColor Green
    
    Write-Host "`nThe backup copy is saved in: $backupPath" -ForegroundColor Gray
    Write-Host "You can delete this folder after 24 hours if everything is working fine" -ForegroundColor Yellow
} else {
    Write-Host "The Windows Temp folder was not found!" -ForegroundColor Red
}

Write-Host "`n=== Done! ===" -ForegroundColor Cyan