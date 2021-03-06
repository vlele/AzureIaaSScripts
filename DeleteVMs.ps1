﻿# -------------------------------------------------------------------------------------------------
 # DeleteVMs - This script deletes existing VMs
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

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 


# Has to be a unique name. Verify with Test-AzureService
$serviceName = 'VLLBWFE3' 

# Server Name
$vmname1 = 'WFE1'

# Server Name
$vmname2 = 'WFE2'




# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 


Remove-AzureVM $serviceName -Name $vmname1
Remove-AzureVM $serviceName -Name $vmname2


Remove-AzureService $serviceName -Force
