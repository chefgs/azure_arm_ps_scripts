$rgname=$args[0]
New-AzureRmStorageAccount -Name storageacct -ResourceGroupName $rgname -Location 'East US 2' -Kind Storage -SkuName Standard_LRS
