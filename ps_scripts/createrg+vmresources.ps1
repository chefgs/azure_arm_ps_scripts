# Log in to Azure
# Login-AzureRmAccount

# Pass number of RG to be created as input arg
if ( $args[0] -eq $null )
{
  Write-Output "No Arguments passed. Pass Number of RG count"
  exit 0
}
else
{
  $vm_count=$args[0]
}

$count=0
do
{
	$rgCount=$count+1
	$rgName="TestRG"+"$rgCount"
	Write-Output "Creating Resource Group $rgName"

	$region = "EastUS2"

	# Create resource group
	New-AzureRmResourceGroup -Name $rgName -Location $region 

	# Create networking resources
	# Create a virtual network, subnet, and a public IP address.
	# Create a subnet configuration
	$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 192.168.1.0/24

	# Create a virtual network
	$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $rgName -Location $region  -Name MYvNET -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

	# Create a public IP address and specify a DNS name
	$pip = New-AzureRmPublicIpAddress -ResourceGroupName $rgName -Location $region -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name "mypublicdns$(Get-Random)"
	
	# Create a network security group and a network security group rule.
	# Create an inbound network security group rule for port 3389
	$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

	# Create an inbound network security group rule for port 80
	$nsgRuleWeb = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleWWW  -Protocol Tcp -Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access Allow

	# Create a network security group
	$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $region  -Name myNetworkSecurityGroup -SecurityRules $nsgRuleRDP,$nsgRuleWeb
	
	# Create a network card for the virtual machine.
	# Create a virtual network card and associate with public IP address and NSG
	$nic = New-AzureRmNetworkInterface -Name myNic -ResourceGroupName $rgName -Location $region -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id
	
	# Create virtual machine
	# Define a credential object
	$SecurePassword = ConvertTo-SecureString "Qwertyuiop.123" -AsPlainText -Force
	$Credential = New-Object System.Management.Automation.PSCredential ("testuser", $SecurePassword); 
	# User Get-Credential cmdlet for getting the username/password interactively
	# $cred = Get-Credential

	# Create a virtual machine configuration
	$vmConfig = New-AzureRmVMConfig -VMName myVM -VMSize Basic_A0 | Set-AzureRmVMOperatingSystem -Windows -ComputerName myVM -Credential $Credential | Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2008-R2-SP1 -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id

	New-AzureRmVM -ResourceGroupName $rgName -Location $region -VM $vmConfig

	$count++
}
while ( $count -ne $vm_count )
