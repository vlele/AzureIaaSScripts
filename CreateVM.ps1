# -------------------------------------------------------------------------------------------------
 # CreateVMs- This script creates uploads VHDs from the local machine and create VMs in Azure
 #                    balanced end points. 
 #
 # To do - 
 #         
 #         1) Specify appropriate values for variables $myCert, $location, $instanceSize, $serviceName
 #
 # -------------------------------------------------------------------------------------------------
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1'

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	

CheckReqVariables

#To get Azure Locations
#Get-AzureLocation | Foreach-Object {$_.GetEnumerator() } | Select-Object Name,DisplayName

# Retreive with Get-AzureLocation 
$location = 'East US' 


# ExtraSmall, Small, Medium, Large, ExtraLarge


$instanceSize = 'Medium' 




# Server Name

$vmname1 = 'VLALM2'



# Source VHDs

$sourceosvhd = 'C:\vhd\Visual Studio 2012 Update 1 RTM ALM\Virtual Hard Disks\BL_WS2008R2SP1x64Std.vhd'

#$sourcedatavhd = 'C:\MyVHDs\AppServer1DataDisk.vhd'



# Target Upload Location 

$destosvhd = 'http://' + $storageAccountName + '.blob.core.windows.net/uploads/BL_WS2008R2SP1x64Std.vhd'
#$destdatavhd = 'https://' + $storageAccountName +'.blob.core.windows.net/uploads/AppServer1DataDisk.vhd'

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint

# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 


# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 



# Has to be a unique name. Verify with Test-AzureService

ReturnUniqueSeriveName $serviceName 


Add-AzureVhd -LocalFilePath $sourceosvhd -Destination $destosvhd 

#Add-AzureVhd -LocalFilePath $sourcedatavhd -Destination $destdatavhd



Add-AzureDisk -OS Windows -MediaLocation $destosvhd -DiskName 'AppServer1OSDisk'

#Add-AzureDisk -MediaLocation $destdatavhd -DiskName 'AppServer1DataDisk'



$migratedVM = New-AzureVMConfig -Name $vmname1 -DiskName 'AppServer1OSDisk' -InstanceSize 'Medium' |
					
#Add-AzureDataDisk -Import -DiskName 'AppServer1DataDisk' -LUN 0 |
					
Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp 
					


New-AzureVM -ServiceName $serviceName -Location $location -VMs $migratedVM 					

