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
#New-AzureQuickVM -Windows -ServiceName $cloudSvcName -Name $vmname -ImageName $image -Password $adminPassword -AffinityGroup $affinityGrp

$imgname = 'WebAppImg'
$cloudsvc = 'tempDNS'
$pass = 'your password'

$iisvm1 = New-AzureVMConfig -Name 'iis1' -InstanceSize Small -ImageName $image |
	Add-AzureEndpoint -Name web -LocalPort 80 -PublicPort 80 -Protocol tcp -LBSetName web -ProbePath '/HealthCheck/HealthCheck.aspx' -ProbeProtocol http -ProbePort 80 |
	Add-AzureEndpoint -Name webdeploy -LocalPort 8080 -PublicPort 8080 -Protocol tcp | 
	Add-AzureProvisioningConfig -Windows -Password $adminPassword
	
$iisvm2 = New-AzureVMConfig -Name 'iis2' -InstanceSize Small -ImageName $image |
	Add-AzureEndpoint -Name web -LocalPort 80 -PublicPort 80 -Protocol tcp -LBSetName web -ProbePath '/HealthCheck/HealthCheck.aspx' -ProbeProtocol http -ProbePort 80 |
	Add-AzureProvisioningConfig -Windows -Password $adminPassword
	

	
New-AzureVM -ServiceName $cloudsvc -VMs $iisvm1,$iisvm2 -AffinityGroup $affinityGrp # -Location 'West US'



#$filename=$cloudSvcName+"_"+$vmname.ToUpper()+"_config.zip"

$filename=$cloudSvcName+"_"+'iis1'.ToUpper()+"_config.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'Config.zip') "blob" $filename

$filename=$cloudSvcName+"_"+'iis2'.ToUpper()+"_config.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'Config.zip') "blob" $filename

#Remove-AzureDeployment -ServiceName "tempDNS" -Slot Production -Force
#Remove-AzureService -ServiceName "tempDNS"
#Remove-AzureDisk -DiskName 'mydisk' -DeleteVHD  