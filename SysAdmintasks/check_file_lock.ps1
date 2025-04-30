function Test-FileLock {
    param([string]$Path)
    try {
        $stream = [System.IO.File]::Open($Path, 'Open', 'ReadWrite', 'None')
        $stream.Close()
        return $false  # Not locked
    } catch {
        return $true   # Locked
    }
}

# Example usage
$filePath = "\\healthbc.org\DEM-Prod-02\HDPBC_admin-new\HDPBC_admin\Cost-Segregation\output\DB_CostSegregation_By_Schema.json"
#$filePath = "\\healthbc.org\DEM-Prod-02\HDPBC_admin-new\HDPBC_admin\Cost-Segregation\output2\DB_CostSegregation_By_Schema.json"
#$filePath = "\\healthbc.org\DEM-Prod-02\HDPBC_admin-new\HDPBC_admin\Cost-Segregation\ADF\dummy.json"

$locked = Test-FileLock -Path $filePath
if ($locked) {
    Write-Output "$filePath is locked."
} else {
    Write-Output "$filePath is not locked."
}
