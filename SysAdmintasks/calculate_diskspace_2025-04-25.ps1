# Define the path to the shared folder
$sharedPath = "\\ab.org\DEM-Prod-02\shared"
# $sharedPath = "\\ab.com\DEM-Prod-02\shared\DBT_Testing"


# Get all immediate subfolders of the shared folder
$folders = Get-ChildItem -Path $sharedPath -Directory

$outputFolder = "\\ab.org\Cost-Segregation\output"

$processed = "\\ab.org\Cost-Segregation\processed"

$timestamp_File = Get-Date -Format "yyyy-MM-dd_HH_mm_ss"

# Ensure processed folder exists
if (-not (Test-Path $processed)) {
    New-Item -ItemType Directory -Path $processed | Out-Null
}

# Process all files in the $outputFolder folder
Get-ChildItem -Path $outputFolder -File | ForEach-Object {
    $originalFileName = $_.Name
    $newFileName = "$timestamp_File-$originalFileName"
    $destinationPath = Join-Path -Path $processed -ChildPath $newFileName

    # Move and rename the file
    Move-Item -Path $_.FullName -Destination $destinationPath
}

# Optional: Confirm $outputFolder folder is now empty
if (-not (Get-ChildItem -Path $outputFolder)) {
    Write-output  "All files moved. '$outputFolder' is now empty."
} else {
    Write-Warning "'$outputFolder' is not empty!"
}

# Create an array to store the results
$results = @()

# Get the current timestamp
$timestamp_Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Create output file path with timestamp_File
$outputFile_Temp = Join-Path -Path $outputFolder -ChildPath "DB_CostSegregation_By_Schema_temp.csv"
$outputFile = Join-Path -Path $outputFolder -ChildPath "DB_CostSegregation_By_Schema.csv"

# Process each folder
foreach ($folder in $folders) {
    # Calculate the total size of the folder including all subfolders and files
    $size = Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | 
            Measure-Object -Property Length -Sum

    # Create a custom object with the folder information
    $folderInfo = [PSCustomObject]@{
		TimeGenerated = $timestamp_Date
		objectType = "Shared Folder"
        SchemaName = $folder.Name
        # FullPath = $folder.FullName
        SizeInMB = [math]::Round(($size.Sum / 1MB), 0)  # Convert bytes to MB and round to 2 decimal places
		UsedInMB = 0
		DataInMB  = 0
    }
    
    # Add to results array
    $results += $folderInfo
}

# Display results sorted by size (largest first)
# $results | Sort-Object -Property SizeInMB -Descending | Format-Table -AutoSize 
# | Export-Csv -Path outputFile -NoTypeInformation

# Optionally, export to CSV
 $results | Export-Csv -Path $outputFile_Temp -NoTypeInformation
 
 # Read the file, filter out lines containing ',"0","0","0"', and write to a new file
Get-Content $outputFile_Temp | Where-Object { $_ -notmatch  '\"0\",\"0\",\"0\"' } | Set-Content $outputFile


# === Convert CSV to JSON with numeric enforcement ===
try {
    Write-Output "Converting CSV to JSON..."

    $csvData = Import-Csv -Path $outputFile

    $convertedData = foreach ($row in $csvData) {
        $row.SizeInMB = [int]$row.SizeInMB
        $row.UsedInMB = [int]$row.UsedInMB
        $row.DataInMB = [int]$row.DataInMB
        ($row)  # Fixed: return the row object explicitly
    }

    $jsonData = $convertedData | ConvertTo-Json -Depth 10

    $jsonFile = [System.IO.Path]::ChangeExtension($outputFile, "json")
    $jsonData | Out-File -FilePath $jsonFile -Encoding utf8

    Write-Output "JSON file saved as: $jsonFile"
} catch {
    Write-Output "Failed to convert CSV to JSON: $_"
}

if (![string]::IsNullOrWhiteSpace($outputFile_Temp) -and (Test-Path $outputFile_Temp)) {
    Remove-Item $outputFile_Temp -Force
}
