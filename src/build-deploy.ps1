# Define the version file path
$versionFile = ".\version.txt"

# Check if the version file exists
if (-Not (Test-Path $versionFile)) {
    # Initialize with version 1 and current timestamp
    "1-$(Get-Date -Format 'yyyyMMdd-HHmmss')" | Set-Content $versionFile
}

# Read the current version
$currentVersion = Get-Content $versionFile

# Extract the leading version number and timestamp
if ($currentVersion -match "(\d+)-(\d{8}-\d{6})") {
    $versionNumber = [int]$matches[1] + 1  # Increment the version number
} else {
    # Fallback if format is incorrect
    $versionNumber = 1
}

# Generate the new version with updated timestamp
$newVersion = "$versionNumber-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$newVersion | Set-Content $versionFile

Write-Host "Updated version: $newVersion"

# Proceed with the original commands
hugo build
git add ..\docs\*
git add $versionFile  # Ensure the version file is committed
git commit -m "publish website - version $newVersion"
git push
