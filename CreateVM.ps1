# -------------------------------------------------------------------------------------------------
 # CreateVMs- This script creates uploads VHDs from the local machine and create VMs in Azure
 #                    balanced end points. 
 #
 # To do - 
 #         1) Create a file within a subfolder called "include" and add a script  
 #            file called SubscriptionInfo.ps1 with the following variables 
 # 
 #            $subscriptionName
 #            $storageAccountName
 #            $subscriptionId
 #            $storageAccountName
 #            $thumbPrint  
 #         
 #         2) Specify appropriate values for variables $myCert, $location, $instanceSize, $serviceName
 #
 # -------------------------------------------------------------------------------------------------

# include the subscription info
. C:\Users\vishwas.lele\Documents\MyScripts\include\SubscriptionInfo.ps1


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


# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 


# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 


Add-AzureVhd -LocalFilePath $sourceosvhd -Destination $destosvhd 

#Add-AzureVhd -LocalFilePath $sourcedatavhd -Destination $destdatavhd



Add-AzureDisk -OS Windows -MediaLocation $destosvhd -DiskName 'AppServer1OSDisk'

#Add-AzureDisk -MediaLocation $destdatavhd -DiskName 'AppServer1DataDisk'



$migratedVM = New-AzureVMConfig -Name $vmname1 -DiskName 'AppServer1OSDisk' -InstanceSize 'Medium' |
					
#Add-AzureDataDisk -Import -DiskName 'AppServer1DataDisk' -LUN 0 |
					
Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp 
					


New-AzureVM -ServiceName $serviceName -Location $location -VMs $migratedVM 					

