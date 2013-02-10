# -------------------------------------------------------------------------------------------------
 # ImportCRMSetup - This script exports the existing VM configuration
 
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





# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 
# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 


$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 
$vnetName = "Appliediscloud-AZ-DataCenter"

#ais-crm-ad
$cloudService = "ais-crm-dc"
$vm = "ais-crm-ad"
$ImportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$vm-config.xml" 
Import-AzureVM -Path $ImportPath | New-AzureVM -ServiceName $cloudService -VNetName $vnetName 
Start-AzureVM -ServiceName $cloudService -name $vm 



#ais-crm-sql
$cloudService = "ais-crm-sql"
$vm = "ais-crm-sql"
$ImportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$vm-config.xml" 
Import-AzureVM -Path $ImportPath | New-AzureVM -ServiceName $cloudService -VNetName $vnetName 
Start-AzureVM -ServiceName $cloudService -name $vm

# Note VMs ais-crm-web1 and ais-crm-web3 are part of the same cloud service
#ais-crm-web1
$cloudService = "ais-crm-web1"
$vm = "ais-crm-web1"
$ImportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$vm-config.xml" 
Import-AzureVM -Path $ImportPath | New-AzureVM -ServiceName $cloudService -VNetName $vnetName 
Start-AzureVM -ServiceName $cloudService -name $vm

#ais-crm-web3
# No need to specify the vnet name here as the service is already created
$cloudService = "ais-crm-web1"
$vm = "ais-crm-web3"
$ImportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$vm-config.xml" 
Import-AzureVM -Path $ImportPath | New-AzureVM -ServiceName $cloudService 
Start-AzureVM -ServiceName $cloudService -name $vm

