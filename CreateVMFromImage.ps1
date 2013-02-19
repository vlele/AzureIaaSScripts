$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	
. (Join-Path $ScriptDirectory 'AzureWrappers.ps1')

CheckReqVariables

#variables

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint
# Specify the storage account location to store the newly created VH
#Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert

Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount $storageAccountName
$image= "TemplateVM"

$adminPassword = 'Password1'
$vmname = "mytestvm1"
$cloudSvcName = "tempDNS"
$affinityGrp = 'VNAffinity'
New-AzureQuickVM -Windows -ServiceName $cloudSvcName -Name $vmname -ImageName $image -Password $adminPassword -AffinityGroup $affinityGrp
$filename=$cloudSvcName+"_"+$vmname+"_config.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'Config.zip') "blob" $filename