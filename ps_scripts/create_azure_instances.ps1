# Login-AzureRmAccount 

# Create Resource Group: Run create_rg.ps1

$rgName=$args[0]
$templateFile=$args[1]
$paramFile=$args[2]

# Get Start Time
$startDTM = (Get-Date)
Write-Output "Start Time : $startDTM"

# $ScriptPath = Split-Path $MyInvocation.InvocationName & "$ScriptPath\create_rg.ps1"
# .\create_rg.ps1

New-AzureRmResourceGroupDeployment -Name "BulkVMcreation$(Get-Random -Maximum 1000)" -ResourceGroupName $rgName -TemplateFile $templateFile -TemplateParameterFile $paramFile

# Get End Time
$endDTM = (Get-Date)
Write-Output "End Time : $endDTM"

# Echo Time elapsed
Write-Output "Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"
