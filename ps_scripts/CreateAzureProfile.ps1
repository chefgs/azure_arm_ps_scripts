$userName = "saravanan.coadmin@acpcloud975hotmail.onmicrosoft.com"

$securePassword = ConvertTo-SecureString -String "pwd_string" -AsPlainText -Force

$cred = New-Object System.Management.Automation.PSCredential($userName, $securePassword)

$tempFile = "login-temp.txt"

$azureProfileFile = "azureprofile.json"

# Get subscriptionId detail
Add-AzureRmAccount -Credential $cred > $tempFile
$subsIDTemp = type .\$tempFile | Select-String -SimpleMatch "SubscriptionId" -CaseSensitive
$subscriptionId = $subsIDTemp.line.Split(":")[1].Trim()

Select-AzureRmSubscription -SubscriptionId $subscriptionId

Save-AzureRmProfile -Path $azureProfileFile -Force

Remove-Item $tempFile

# Select-AzureRmProfile -Path "azureprofile.json"
# Get-AzureRmApplicationGateway
