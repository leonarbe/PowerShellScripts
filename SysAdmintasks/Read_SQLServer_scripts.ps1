#Import-Module Az
#Install-Module -Name SqlServer -Scope CurrentUser -AllowClobber -Force
Import-Module SqlServer

# Define connection parameters
$server = "hdpbc-datasets01.f8cdec14aad0.database.windows.net"
$database = "HDPBC"

# Import Az module
#Import-Module Az

# Define variables
$tenantId = "31f660a5-192a-4db3-92ba-ca424f1b259e"
$subscriptionId = "1663d551-3d1b-499d-bf5b-5b187c02206f"
$resourceUri = "https://database.windows.net"


# Login to Azure with additional authentication scope
Connect-AzAccount -TenantId $tenantId -AuthScope $resourceUri

# Obtain access token
$accessToken = (Get-AzAccessToken -ResourceUrl $resourceUri).Token

$queryFilePath = "query.sql" # external SQL file location
$query = Get-Content -Path $queryFilePath -Raw

# Check if access token is not empty
if ($accessToken) {
    # Execute query using access token
    Invoke-SqlCmd -ServerInstance $server -Database $database -AccessToken $accessToken -Query $query | Export-Csv -Path "output.csv" -NoTypeInformation
} else {
    Write-Host "Failed to obtain access token."
}
