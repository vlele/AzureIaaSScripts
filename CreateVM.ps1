# Retrieve with Get-AzureSubscription 

$subscriptionName = 'ais'  

$storageAccountName = 'ais2'   

$subscriptionId  = '66cacb0f-a871-4b0b-a161-bd04492f956a'

$thumbPrint = '2EB9DD83557985E63FBFBBD2E7308B5093F2CAB2'

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 


# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 


# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 



# Retreive with Get-AzureLocation 
$location = 'East US' 


# ExtraSmall, Small, Medium, Large, ExtraLarge


$instanceSize = 'Medium' 



# Has to be a unique name. Verify with Test-AzureService

$serviceName = 'VLALM2' 



# Server Name

$vmname1 = 'VLALM2'



# Source VHDs

$sourceosvhd = 'C:\vhd\Visual Studio 2012 Update 1 RTM ALM\Virtual Hard Disks\BL_WS2008R2SP1x64Std.vhd'

#$sourcedatavhd = 'C:\MyVHDs\AppServer1DataDisk.vhd'



# Target Upload Location 

$destosvhd = 'http://' + $storageAccountName + '.blob.core.windows.net/uploads/BL_WS2008R2SP1x64Std.vhd'
#$destdatavhd = 'https://' + $storageAccountName +'.blob.core.windows.net/uploads/AppServer1DataDisk.vhd'



Add-AzureVhd -LocalFilePath $sourceosvhd -Destination $destosvhd 

#Add-AzureVhd -LocalFilePath $sourcedatavhd -Destination $destdatavhd



Add-AzureDisk -OS Windows -MediaLocation $destosvhd -DiskName 'AppServer1OSDisk'

#Add-AzureDisk -MediaLocation $destdatavhd -DiskName 'AppServer1DataDisk'



$migratedVM = New-AzureVMConfig -Name $vmname1 -DiskName 'AppServer1OSDisk' -InstanceSize 'Medium' |
					
#Add-AzureDataDisk -Import -DiskName 'AppServer1DataDisk' -LUN 0 |
					
Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp 
					


New-AzureVM -ServiceName $serviceName -Location $location -VMs $migratedVM 					

