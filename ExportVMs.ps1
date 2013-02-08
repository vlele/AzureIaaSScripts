# -------------------------------------------------------------------------------------------------
 # ExportVms - This script exports the existing VM configuration
 
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


$cloudSvcName = 'az-ad-01'
# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 
$vmname = 'az-ad-01' 
Export-AzureVM -ServiceName $cloudSvcName -Name $vmname -Path 'c:\Temp\mytestvm1-config.xml' -Verbose