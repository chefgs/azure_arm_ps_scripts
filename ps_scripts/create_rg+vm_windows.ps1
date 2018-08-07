# Log in to Azure
# Login-AzureRmAccount

# Pass the VM count as input argument
if ( $args[0] -eq $null )
{
  Write-Output "No Arguments passed. Provide the VM count as input argument"
  exit 0
}
else
{
  $vm_count=$args[0]
}

$rgName="TestRG"

$region = "EastUS2"

Write-Output "Creating Resource Group $rgName in region $region"

# Create resource group
New-AzureRmResourceGroup -Name $rgName -Location $region

# Create networking resources
# Create a virtual network, subnet, and a public IP address.
# Create a subnet configuration
Write-Output "Creating Subnet Config"
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 192.168.1.0/24

# Create a virtual network
Write-Output "Creating VirtualNetwork"
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $rgName -Location $region  -Name MYvNET -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig
	
# Create a network security group and a network security group rule.
# Create an inbound network security group rule for port 3389
Write-Output "Creating nsgRule for RDP"
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

# Create an inbound network security group rule for port 80
Write-Output "Creating nsgRule for Web"
$nsgRuleWeb = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleWWW  -Protocol Tcp -Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access Allow

# Create a network security group
Write-Output "Creating NetworkSecurityGroup"
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $region  -Name myNetworkSecurityGroup -SecurityRules $nsgRuleRDP,$nsgRuleWeb

$count=0
do
{
	$pipName="mypublicdns$(Get-Random)"
	Write-Output "Creating Public IP resource named as $pipName"
	$pip = New-AzureRmPublicIpAddress -ResourceGroupName $rgName -Location $region -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name $pipName
		
	# Get a network card for the virtual machine.
	# Get a virtual network card and associate with public IP address and NSG
	# $nic = Get-AzureRmNetworkInterface -Name myNic -ResourceGroupName $rgName
	$nicName="myNic$(Get-Random)"
	Write-Output "Creating NIC $nicName"
	$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $region -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id
	
	# Create virtual machine
	# Define a credential object
	$SecurePassword = ConvertTo-SecureString "Qwertyuiop.123" -AsPlainText -Force
	$Credential = New-Object System.Management.Automation.PSCredential ("testuser", $SecurePassword); 
	# User Get-Credential cmdlet for getting the username/password interactively
	# $cred = Get-Credential
	
	$vmCount=$count+1
	$vmName="TestVM"+"$vmCount"
	
	Write-Output "Creating VM : $vmName under Resource Group $rgName"
	# Create a virtual machine configuration
	$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize Basic_A0 | Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $Credential | Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2008-R2-SP1 -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id

	New-AzureRmVM -ResourceGroupName $rgName -Location $region -VM $vmConfig

	$count++
}
while ( $count -ne $vm_count )
