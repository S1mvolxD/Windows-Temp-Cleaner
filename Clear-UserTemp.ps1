# Clearing the current user's temporary files
# Does not require administrator rights

Write-Host "=== Clearing user's temporary files ===" -ForegroundColor Cyan

$tempFolders = @(
    "$env:TEMP\*",
    "$env:LOCALAPPDATA\Temp\*",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*",
    "$env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\*",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default-release\cache2\entries\*",
    "$env:APPDATA\Microsoft\Windows\Recent\*",
    "$env:LOCALAPPDATA\Microsoft\Windows\WER\ReportArchive\*"
)

$totalSize = 0
$deletedFiles = 0

foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        $folderPath = Split-Path $folder -Parent
        Write-Host "Clearing: $folderPath" -ForegroundColor Yellow
        
        $files = Get-ChildItem -Path $folder -Recurse -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            try {
                Remove-Item $file.FullName -Recurse -Force -ErrorAction SilentlyContinue
                $deletedFiles++
                $totalSize += $file.Length
            } catch {

            }
        }
    }
}

$sizeInMB = [math]::Round($totalSize / 1MB, 2)

Write-Host "`Result:" -ForegroundColor Green
Write-Host "Deleted files: $deletedFiles" -ForegroundColor Green
Write-Host "Seats have been vacated: $sizeInMB MB" -ForegroundColor Green


Write-Host "`nClearing the DNS cache..." -ForegroundColor Cyan
ipconfig /flushdns | Out-Null # Clearing the DNS cache
Write-Host "DNS cache cleared" -ForegroundColor Green

Write-Host "`n=== Done! ===" -ForegroundColor Cyan