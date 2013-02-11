$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	

CheckReqVariables

# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 


# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 



# Retreive with Get-AzureLocation 
$location = 'East US' 


# ExtraSmall, Small, Medium, Large, ExtraLarge
$instanceSize = 'Medium' 



# Has to be a unique name. Verify with Test-AzureService
$serviceName = 'VLALM4' 



# Server Name
$vmname1 = 'VLALM4'


$migratedVM = New-AzureVMConfig -Name $vmname1 -DiskName 'AppServer1OSDisk' -InstanceSize 'Medium' |
					
	Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp 
					

New-AzureVM -ServiceName $serviceName -Location $location -VMs $migratedVM 					

