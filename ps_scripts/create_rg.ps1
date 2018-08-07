# Log in to Azure
# Login-AzureRmAccount

$rgName=$args[0]
Write-Output "Creating Resource Group $rgName"

$region = "EastUS2"

# Create resource group
New-AzureRmResourceGroup -Name $rgName -Location $region 
