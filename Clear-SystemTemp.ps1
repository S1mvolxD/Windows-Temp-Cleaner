# Cleaning system temporary files
# RUN AS AN ADMINISTRATOR IS REQUIRED

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator rights!" -ForegroundColor Red
    Write-Host "Run PowerShell as an administrator" -ForegroundColor Yellow
    exit 1
} # Checking administrator rights

Write-Host "=== Cleaning system temporary files ===" -ForegroundColor Cyan

$systemTempFolders = @(
    "C:\Windows\Temp\*",
    "C:\Windows\System32\config\systemprofile\AppData\Local\Temp\*",
    "C:\Windows\Logs\CBS\*",
    "C:\Windows\SoftwareDistribution\Download\*",
    "C:\Windows\Installer\$PatchCache$\Managed\*",
    "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp\*",
    "C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\*"
)

$totalSize = 0
$deletedFiles = 0

foreach ($folder in $systemTempFolders) {
    if (Test-Path $folder) {
        $folderPath = Split-Path $folder -Parent
        Write-Host "Clearing: $folderPath" -ForegroundColor Yellow
        
        # Stop the update service if you clean the SoftwareDistribution
        if ($folder -like "*SoftwareDistribution*") {
            Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
            Write-Host "The update service has been stopped" -ForegroundColor Gray
        }
        
        $files = Get-ChildItem -Path $folder -Recurse -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            try {
                Remove-Item $file.FullName -Recurse -Force -ErrorAction SilentlyContinue
                $deletedFiles++
                $totalSize += $file.Length
            } catch {

            }
        }
        
        # Launching the update service back
        if ($folder -like "*SoftwareDistribution*") {
            Start-Service wuauserv -ErrorAction SilentlyContinue
            Write-Host "The update service is running" -ForegroundColor Gray
        }
    }
}

$sizeInMB = [math]::Round($totalSize / 1MB, 2)
Write-Host "`nResult:" -ForegroundColor Green
Write-Host "Deleted files: $deletedFiles" -ForegroundColor Green
Write-Host "Seats have been vacated: $sizeInMB MB" -ForegroundColor Green

Write-Host "`n=== Done! ===" -ForegroundColor Cyan