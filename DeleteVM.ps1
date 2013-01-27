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

# Has to be a unique name. Verify with Test-AzureService
$serviceName = 'VLALM2' 

# Server Name

$vmname1 = 'VLALM2'

Remove-AzureVM -Name $vmname1 -ServiceName $ServiceName