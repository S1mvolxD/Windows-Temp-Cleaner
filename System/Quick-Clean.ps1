# Quick-Clean.ps1 (v1) - A very basic option.

Clear-Host
Write-Host "======== Cleaning management menu. ========" -ForegroundColor Cyan
Write-Host "1. Deleting the trash."
Write-Host "0. Exit"
Write-Host "===========================================" -ForegroundColor Cyan

$choice = Read-Host "Select an option (0-1)"

switch ($choice) {
    "0" {
        Write-Host "Exit..." -ForegroundColor Red
        exit
    }
    "1" {
        Write-Host "Basket analysis..." -ForegroundColor Yellow

        $RecycleBin = New-Object -ComObject Shell.Application # Get the size of the current user's shopping cart (in bytes)
        $RecycleBinItems = $RecycleBin.NameSpace(10).Items() # Please note that NameSpace(10) corresponds to the Recycle Bin folder
        $TotalSizeBefore = 0
        foreach ($item in $RecycleBinItems) {
            $TotalSizeBefore += $item.Size
        }

        function Format-FileSize {
            param([long]$Size)
            if ($Size -ge 1GB) { return "{0:N2} GB" -f ($Size / 1GB) }
            elseif ($Size -ge 1MB) { return "{0:N2} MB" -f ($Size / 1MB) }
            elseif ($Size -ge 1KB) { return "{0:N2} KB" -f ($Size / 1KB) }
            else { return "$Size Bytes" }
        } # Format the size for easy reading

        $FormattedSizeBefore = Format-FileSize -Size $TotalSizeBefore

        if ($TotalSizeBefore -gt 0) {
            Write-Host "Found data in the bucket: $FormattedSizeBefore" -ForegroundColor Yellow

            Clear-RecycleBin -Force -ErrorAction SilentlyContinue # Emptying the basket
            Write-Host "The basket is cleared. Released: $FormattedSizeBefore" -ForegroundColor Green
        } else {
            Write-Host "The basket is already empty." -ForegroundColor Gray
        }
         Start-Sleep -Seconds 2
    }
    Default {
        Write-Host "Wrong choice!" -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}
