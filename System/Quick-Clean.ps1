# Quick-Clean.ps1 (v0.1) - A very basic option.
Write-Host "The script for cleaning temporary files is running." -ForegroundColor Green

# 1. Defining the target folder
$targetFolder = $env:TEMP

# 2. We show you what's in it.
Write-Host "Содержимое папки $($targetFolder):" -ForegroundColor Yellow
Get-ChildItem -Path $targetFolder

# 3. Request confirmation from the user
$userAnswer = Read-Host "Do you really want to delete these files? (Yes/No)"

if ($userAnswer -eq 'Yes') {
    # 4. Deleting it!
    Remove-Item -Path "$($targetFolder)\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "The folder has been cleared!" -ForegroundColor Green
}  else {
    Write-Host "The operation was canceled by the user." -ForegroundColor Red
}

