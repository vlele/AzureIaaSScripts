

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	
. (Join-Path $ScriptDirectory 'DNSHelper.ps1')	

CheckReqVariables

#variables

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint
$configFilePa = "C:\Temp\exp.netcfg"
$LocalVnetName = "YourCorpHQ"
$RemoteVnetName = "RemoteVnet"
$AffinityGroupName = "VNAffinity"
$location = 'East US' 
$NewVnetName = "AzureVnet"
$LocalVnet = "LocalVnet"
$LocalDNSIPAddress="8.8.8.8"
$LocalGatewayIP="182.73.13.222"


$DNSServers= ForEach-Object {
  Get-WMIObject Win32_NetworkAdapterConfiguration -Computername localhost | `
  Where-Object {$_.IPEnabled -match "True"} | `
  Select  DNSServerSearchOrder
}
$DNSServerValue=  $DNSServers.DNSServerSearchOrder[0]

# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 IF(Test-Path $configFilePa)
{
 remove-item $configFilePa
 }
 
 Get-AzureVNetConfig -ExportToFile $configFilePa
 
IF(Test-Path $configFilePa)
{
	Write-Error "Already A network Exists"
	exit
}


#check if affinity group exists

	Get-AzureAffinityGroup -Name $AffinityGroupName

if ($error[0])
 {
	New-AzureAffinityGroup -Name $AffinityGroupName -Location $location
 }

$xml = [xml](get-content (Join-Path $ScriptDirectory 'VPNCfg.xml'))
$xml.NetworkConfiguration.VirtualNetworkConfiguration.Dns.DnsServers.DnsServer| where { $_.name -eq "YourDNS" } | foreach { $_.SetAttribute("IPAddress", $LocalDNSIPAddress) }
$xml.NetworkConfiguration.VirtualNetworkConfiguration.VirtualNetworkSites.VirtualNetworkSite | where { $_.name -eq "YourVirtualNetwork" } | foreach { $_.SetAttribute("name", $NewVnetName) } 
$xml.NetworkConfiguration.VirtualNetworkConfiguration.VirtualNetworkSites.VirtualNetworkSite| where { $_.name -eq $NewVnetName } | foreach { $_.SetAttribute("AffinityGroup", $AffinityGroupName) } 

$xml.NetworkConfiguration.VirtualNetworkConfiguration.LocalNetworkSites.LocalNetworkSite.VPNGatewayAddress=$LocalGatewayIP
$xml.Save((Join-Path $ScriptDirectory 'NewVPNCfg.xml'))

Set-AzureVNetConfig -ConfigurationPath (Join-Path $ScriptDirectory 'NewVPNCfg.xml')
 
New-AzureVNetGateway –VNetName $NewVnetName
do
{
$VIPAddress =  Get-AzureVNetGateway –VNetName $NewVnetName|Select VIPAddress
}while($VIPAddress.get_Length -eq 0)

Set-AzureVNetGateway -Connect –LocalNetworkSiteName $LocalVnet –VNetName $NewVnetName
#Get-AzureVNetGateway -VNetName $NewVnetName

Get-AzureVNetGatewayKey -LocalNetworkSiteName $LocalVnet -VNetName $NewVnetName