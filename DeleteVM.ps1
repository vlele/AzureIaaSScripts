$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	

CheckReqVariables

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