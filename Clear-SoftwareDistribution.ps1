# Cleaning the Windows Updates folder (SoftwareDistribution)
# RUN AS AN ADMINISTRATOR IS REQUIRED

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator rights!" -ForegroundColor Red
    Write-Host "Run PowerShell as an administrator" -ForegroundColor Yellow
    exit 1
} # Checking administrator rights

Write-Host "=== Clearing the Windows Update folder ===" -ForegroundColor Cyan

$softwareDistPath = "C:\Windows\SoftwareDistribution"
$downloadPath = "$softwareDistPath\Download"

Write-Host "I'm stopping the update services..." -ForegroundColor Yellow

# Stopping services related to updates
$services = @("wuauserv", "bits", "cryptsvc")
foreach ($service in $services) {
    try {
        Stop-Service $service -Force -ErrorAction SilentlyContinue
        Write-Host "  Stopped: $service" -ForegroundColor Gray
    } catch {
        Write-Host "  Couldn't stop: $service" -ForegroundColor Red
    }
}

Start-Sleep -Seconds 2

Write-Host "`nI'm clearing the updates folder..." -ForegroundColor Yellow

if (Test-Path $softwareDistPath) {
    # Saving settings and logs
    $backupItems = @(
        "$softwareDistPath\EventCache",
        "$softwareDistPath\DataStore\DataStore.edb",
        "$softwareDistPath\DataStore\Logs"
    )
    
    $backupPath = "$env:TEMP\UpdateBackup"
    if (Test-Path $backupPath) {
        Remove-Item $backupPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    
    foreach ($item in $backupItems) {
        if (Test-Path $item) {
            Copy-Item -Path $item -Destination $backupPath -Recurse -ErrorAction SilentlyContinue
        }
    }
    
    # Deleting the contents of the Download folder
    if (Test-Path $downloadPath) {
        $files = Get-ChildItem -Path $downloadPath -Recurse -ErrorAction SilentlyContinue
        $fileCount = $files.Count
        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum
        
        Remove-Item "$downloadPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  The Download folder has been cleared" -ForegroundColor Gray
    }
    
    # Clearing the ReportingEvents.log
    $logFile = "$softwareDistPath\ReportingEvents.log"
    if (Test-Path $logFile) {
        Clear-Content $logFile -ErrorAction SilentlyContinue
        Write-Host "  The event log has been cleared" -ForegroundColor Gray
    }
    
    $sizeInMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "`nResult:" -ForegroundColor Green
    Write-Host "Deleted files: $fileCount" -ForegroundColor Green
    Write-Host "Seats have been vacated: $sizeInMB MB" -ForegroundColor Green
} else {
    Write-Host "The SoftwareDistribution folder was not found!" -ForegroundColor Red
}

Write-Host "`nI'm launching update services..." -ForegroundColor Yellow

foreach ($service in $services) {
    try {
        Start-Service $service -ErrorAction SilentlyContinue
        Write-Host "  Launched: $service" -ForegroundColor Gray
    } catch {
        Write-Host "  Failed to launch: $service" -ForegroundColor Red
    }
}

Write-Host "`nWARNING: After cleaning, you may need to restart the Windows Update service" -ForegroundColor Yellow
Write-Host "Run: services.msc → Windows Update → Restart" -ForegroundColor Gray

Write-Host "`n=== Done! ===" -ForegroundColor Cyan