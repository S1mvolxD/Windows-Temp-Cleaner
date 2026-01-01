# Emptying the trash for all users
# Does not require administrator rights

Write-Host "=== Emptying the trash ===" -ForegroundColor Cyan

$RecycleBin = New-Object -ComObject Shell.Application
$RecycleBinItems = $RecycleBin.NameSpace(10).Items()
$TotalSizeBefore = 0
foreach ($item in $RecycleBinItems) {
    $TotalSizeBefore += $item.Size
}

function Format-FileSize {
    param([long]$Size)
    if ($Size -ge 1GB) { return "{0:N2} GB" -f ($Size / 1GB) }
    elseif ($Size -ge 1MB) { return "{0:N2} MB" -f ($Size / 1MB) }
    elseif ($Size -ge 1KB) { return "{0:N2} KB" -f ($Size / 1KB) }
    else { return "$Size Byte" }
}

$FormattedSizeBefore = Format-FileSize -Size $TotalSizeBefore

if ($TotalSizeBefore -gt 0) {
    Write-Host "Found data in the bucket: $FormattedSizeBefore" -ForegroundColor Yellow
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "The basket is cleared. Released: $FormattedSizeBefore" -ForegroundColor Green
} else {
    Write-Host "The basket is already empty." -ForegroundColor Gray
}

Write-Host "`n=== Done! ===" -ForegroundColor Cyan
