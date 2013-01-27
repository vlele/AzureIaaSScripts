PowerShell_ISE
https://github.com/WindowsAzure/azure-sdk-tools/downloads


$thumbprint = '2EB9DD83557985E63FBFBBD2E7308B5093F2CAB2'
$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint


# Retrieve with Get-AzureSubscription 

$subscriptionName = 'Azdem194I33542W'  



# Retreive with Get-AzureStorageAccount 

$storageAccountName = 'vldemos'   







# Retreive with Get-AzureLocation 
$location = 'East US' 


# ExtraSmall, Small, Medium, Large, ExtraLarge


$instanceSize = 'Medium' 



# Has to be a unique name. Verify with Test-AzureService

$serviceName = 'VLALM1' 



# Server Name

$vmname1 = 'VLALM1'



# Source VHDs

$sourceosvhd = 'C:\vhd\Visual Studio 2012 Update 1 RTM ALM\Virtual Hard Disks\BL_WS2008R2SP1x64Std'

#$sourcedatavhd = 'C:\MyVHDs\AppServer1DataDisk.vhd'



# Target Upload Location 

$destosvhd = 'http://' + $storageAccountName + '.blob.core.windows.net/uploads/BL_WS2008R2SP1x64Std.vhd'
#$destdatavhd = 'http://' + $storageAccountName +'.blob.core.windows.net/uploads/AppServer1DataDisk.vhd'


 

#Add-AzureVhd -LocalFilePath $sourcedatavhd -Destination $destdatavhd

# Specify the storage account location to store the newly created VHDs 

Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount $storageAccountName -Certificate $myCert 
 


# Select the correct subscription (allows multiple subscription support) 

Select-AzureSubscription -SubscriptionName $subscriptionName  

Add-AzureDisk -OS Windows -MediaLocation $destosvhd -DiskName 'BL_WS2008R2SP1x64Std'

#Add-AzureDisk -MediaLocation $destdatavhd -DiskName 'AppServer1DataDisk'



$migratedVM = New-AzureVMConfig -Name $vmname1 -DiskName 'AppServer1OSDisk' -InstanceSize 'Medium' |
					
#Add-AzureDataDisk -Import -DiskName 'AppServer1DataDisk' -LUN 0 |
					
Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp 
					


New-AzureVM -ServiceName $serviceName -Location $location -VMs $migratedVM 					



