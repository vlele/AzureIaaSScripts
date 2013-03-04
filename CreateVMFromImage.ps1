# -------------------------------------------------------------------------------------------------
 # CreateVMs- This script creates load balanced VM from the preped image to run the inital scripts  #                    balanced end points. 
 #
 # To do - 
 #         
 #         1) Specify appropriate values for variables 
 #			$image= This is the preped image name 
#			$adminPassword = Admin password for the VM
#			$cloudSvcName = This name should be unique  Test-AzureName -Service is failing few times
#			$affinityGrp = Make sure the Affinity group and the storageAccountName are in same Geographic data else it will fail
 #
 # -------------------------------------------------------------------------------------------------

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
$cloudSvcName = "tempDNS123" 
$affinityGrp = 'VNAffinity'

$IsAffinityCorrect = Test-AzureName -Service -Name $affinityGrp
if($IsAffinityCorrect  -eq $false)
{
	Write-Error "Affinity Group not found"
		exit
}

$iisvm1 = New-AzureVMConfig -Name 'iis1' -InstanceSize Small -ImageName $image |
	Add-AzureEndpoint -Name web -LocalPort 80 -PublicPort 80 -Protocol tcp -LBSetName web -ProbePath '/HealthCheck/HealthCheck.aspx' -ProbeProtocol http -ProbePort 80 |
	Add-AzureEndpoint -Name webdeploy -LocalPort 8080 -PublicPort 8080 -Protocol tcp | 
	Add-AzureProvisioningConfig -Windows -Password $adminPassword
	
$iisvm2 = New-AzureVMConfig -Name 'iis2' -InstanceSize Small -ImageName $image |
	Add-AzureEndpoint -Name web -LocalPort 80 -PublicPort 80 -Protocol tcp -LBSetName web -ProbePath '/HealthCheck/HealthCheck.aspx' -ProbeProtocol http -ProbePort 80 |
	Add-AzureProvisioningConfig -Windows -Password $adminPassword
	

	
New-AzureVM -ServiceName $cloudSvcName -VMs $iisvm1,$iisvm2 -AffinityGroup $affinityGrp # -Location 'West US'


Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount $blobStorageAccountName
#$filename=$cloudSvcName+"_"+$vmname.ToUpper()+"_config.zip"

$filename=$cloudSvcName+"_"+'iis1'.ToUpper()+"_config.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'Config.zip') "blob" $filename

$filename=$cloudSvcName+"_"+'iis2'.ToUpper()+"_config.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'Config.zip') "blob" $filename

#Remove-AzureDeployment -ServiceName "tempDNS" -Slot Production -Force
#Remove-AzureService -ServiceName "tempDNS"
#Remove-AzureDisk -DiskName 'mydisk' -DeleteVHD  

#New-AzureQuickVM -Windows -ServiceName $cloudSvcName -Name $vmname -ImageName $image -Password $adminPassword -AffinityGroup $affinityGrp
#$imgname = 'WebAppImg'
#$cloudsvc = 'tempDNS12345'
#$pass = 'your password'
#$serviceName="tempDNS"
#ReturnUniqueSeriveName($serviceName)