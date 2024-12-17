# Set parameters
$targetSizeKB = 200   # Target filesize in KB
$maxWidth = 1000      # Maximum width in pixels
$outputFolder = "Compressed"  # Folder to save resized and converted images

# Ensure the output folder exists
If (!(Test-Path -Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Get all image files (JPG, PNG, etc.) in the current folder
$images = Get-ChildItem -File | Where-Object { $_.Extension -in ".jpg", ".jpeg", ".png" }

foreach ($image in $images) {
    Write-Output "Processing $($image.Name)..."
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($image.Name)
    $tempFile = "$outputFolder\temp_$baseName.jpg"
    $finalFile = "$outputFolder\$baseName.jpg"
    $bestFile = $null
    $bestSize = [int]::MaxValue

    # Resize the image to max width while maintaining aspect ratio and convert to JPG
    # magick $image.FullName -resize "${maxWidth}x" -format jpg -quality 90 $tempFile

    # If not wanting to reduce size
    magick $image.FullName -format jpg -quality 90 $tempFile

    # Iteratively reduce quality to meet target size
    $success = $false
    for ($quality = 90; $quality -ge 10; $quality -= 5) {
        magick $tempFile -quality $quality $finalFile

        # Check the file size
        $fileSizeKB = (Get-Item $finalFile).Length / 1KB
        if ($fileSizeKB -le $targetSizeKB) {
            Write-Output "Compressed $($image.Name) to $fileSizeKB KB (quality: $quality)"
            $success = $true
            break
        }
        
        # Track the best attempt
        if ($fileSizeKB -lt $bestSize) {
            Copy-Item $finalFile -Destination "$outputFolder\best_$baseName.jpg" -Force
            $bestFile = "$outputFolder\best_$baseName.jpg"
            $bestSize = $fileSizeKB
        }
    }

    # If target size couldn't be met, keep the best attempt
    if (-not $success) {
        Write-Warning "Could not reach target size for $($image.Name). Best size: $bestSize KB"
        if ($bestFile) {
            Move-Item $bestFile -Destination $finalFile -Force
        }
    }

    # Cleanup temp file
    Remove-Item $tempFile
}

Write-Output "Processing complete. Files saved to $outputFolder as JPGs."
