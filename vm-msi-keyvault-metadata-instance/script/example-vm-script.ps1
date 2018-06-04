[CmdletBinding()]
param(    
)

# Source of parameters is metadata-instance: Azure VM Tags according to our tag definition
#
# Docs:
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/instance-metadata-service
try {
    $resultmetadatainstance=Invoke-RestMethod -Method Get -Uri 'http://169.254.169.254/metadata/instance?api-version=2017-08-01' -Headers @{Metadata="true"}
    $metadatainstancehashtable=@{}
    $resultmetadatainstance.compute.tags.Split(';')|ForEach-Object  {
        $metadatainstancehashtable.Add(
            $_.Split(':')[0],
            $_.Split(':')[1]
        )
    }
    $keyvaultName=$metadatainstancehashtable.Get_Item('keyvaultName')
}
catch {
    Write-Error "Error (10): $($Error[0]) - $($Error[0].Exception.InnerException)" -ErrorAction Stop
}

# Aquire an oauth2 access_token for KeyVault (vault.azure.net)
#
# Docs:
# https://docs.microsoft.com/en-us/azure/active-directory/managed-service-identity/how-to-use-vm-token#get-a-token-using-http
try {

    $access_token=Invoke-RestMethod -Method Get -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -Headers @{Metadata="true"}|Select-Object -ExpandProperty access_token
}
catch {        
    Write-Error "Error (20): $($Error[0]) - $($Error[0].Exception.InnerException)" -ErrorAction Stop
}

# Update KeyVault with new Secret 
#
# Docs:
# https://docs.microsoft.com/en-us/rest/api/keyvault/setsecret/setsecret

try {
    # Update KeyVault with new Secret/Password   
    $SecretVault='value that is stored in KeyVault' 
    $Uri='https://{0}.vault.azure.net/secrets/{1}?api-version=2016-10-01' -f $keyvaultName,'secretname-from-script'
    $restResult=Invoke-RestMethod -Method Put -Uri $Uri -Headers @{Authorization="Bearer $access_token"} -ContentType 'application/json' -Body (@{value=$SecretVault}|ConvertTo-Json)
}
catch {        
    Write-Error "Error (30): $($Error[0]) - $($Error[0].Exception.InnerException)" -ErrorAction Stop
}

Write-Output "Completed $($restResult)"