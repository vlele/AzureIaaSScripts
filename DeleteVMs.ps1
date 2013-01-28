# Retrieve with Get-AzureSubscription 

$subscriptionName = 'ais'  

$storageAccountName = 'ais2'   

$subscriptionId  = '66cacb0f-a871-4b0b-a161-bd04492f956a'

$thumbPrint = '2EB9DD83557985E63FBFBBD2E7308B5093F2CAB2'

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 
$avsetwfe = 'high_availability' 
$lbsetwfe = 'load_balanced'

# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 
# Has to be a unique name. Verify with Test-AzureService
$serviceName = 'VLLBWFE2'
# Server Name
$vmname1 = 'WFE1'
# Server Name
$vmname2 = 'WFE2'

# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 


Remove-AzureVM $serviceName -Name $vmname1
Remove-AzureVM $serviceName -Name $vmname2


Remove-AzureService $serviceName -Force
