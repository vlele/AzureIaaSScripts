
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	
. (Join-Path $ScriptDirectory 'AzureWrappers.ps1')

CheckReqVariables

#variables
$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint
$image= "TemplateVM"
$adminPassword = 'Password1'
$cloudSvcName = "tempDNS124" 
$affinityGrp = 'VNAffinity'

#Set the subscription to create the VMs
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount $storageAccountName

#Check if the given affinity group is correct else give error and stop
$IsAffinityCorrect = Get-AzureAffinityGroup -Name $affinityGrp
if($IsAffinityCorrect  -eq $false)
{
	Write-Error "Affinity Group not found"
		exit
}

$machineName = "AdSvr"

#initialize vms config
$iisvm1 = New-AzureVMConfig -Name $machineName -InstanceSize Small -ImageName $image |
	Add-AzureEndpoint -Name webdeploy -LocalPort 8080 -PublicPort 8080 -Protocol tcp | 
	Add-AzureProvisioningConfig -Windows -Password $adminPassword	

#Create vms in network	
New-AzureVM -ServiceName $cloudSvcName -VMs $iisvm1 -AffinityGroup $affinityGrp # -Location 'West US'

#Upload the config with the machine and cloudservice name to blob
#Set subscription for blob config upload
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount $blobStorageAccountName

#Form the config name and upload to blob
$filename=$cloudSvcName+"_"+$machineName.ToUpper()+"_config.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'SysBoot.zip') "blob" $filename

$NewGuid=[system.guid]::NewGuid().ToString()

$filename1=$NewGuid+"_ad01.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'ad01.zip') "blob" $filename1

$filename2=$NewGuid+"_ad02.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'ad02.zip') "blob" $filename2

$filename3=$NewGuid+"_ad03.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'ad03.zip') "blob" $filename3

$filename4=$NewGuid+"_ad04.zip"
UploadFileToBlob (Join-Path $ScriptDirectory 'ad04.zip') "blob" $filename4

$accountName = "sharepoint2013"
$accountKey="i8fS1cbc2CXXe100NeoKR4fbC74p+I7z7Xo5f8tP96zx2QoTn26PbEBg5uVF3gS6U19xrJYtEsCIRRCk8B8OVQ=="
$tableName="InstallList"
$cloudServiceName="TempCloudService"
$emptyGuid=[system.guid]::empty
Import-Module "C:\Users\Arun\Documents\Visual Studio 2012\Projects\TableWrapper\TableWrapper\bin\Release\InstallTask.psd1"
$filename = "http://portalvhdsfrftdk9j6z93q.blob.core.windows.net/blob/" + $filename1
$Guid = Add-InstallationTask -AccountName $accountName -AccountKey $accountKey -TableName $tableName -CloudServiceName $cloudSvcName   -FileLocation $filename -Description "AdScript1" -Remarks "Test Remarks" -Status 0 -MachineName $machineName.ToUpper() -Predecessor "None"

$filename = "http://portalvhdsfrftdk9j6z93q.blob.core.windows.net/blob/" + $filename2
$Guid = Add-InstallationTask -AccountName $accountName -AccountKey $accountKey -TableName $tableName -CloudServiceName $cloudSvcName   -FileLocation $filename -Description "AdScript1" -Remarks "Test Remarks" -Status 0 -MachineName $machineName.ToUpper() -Predecessor $Guid

$filename = "http://portalvhdsfrftdk9j6z93q.blob.core.windows.net/blob/" + $filename3
$Guid = Add-InstallationTask -AccountName $accountName -AccountKey $accountKey -TableName $tableName -CloudServiceName $cloudSvcName   -FileLocation $filename -Description "AdScript1" -Remarks "Test Remarks" -Status 0 -MachineName $machineName.ToUpper() -Predecessor $Guid

$filename = "http://portalvhdsfrftdk9j6z93q.blob.core.windows.net/blob/" + $filename4
$Guid = Add-InstallationTask -AccountName $accountName -AccountKey $accountKey -TableName $tableName -CloudServiceName $cloudSvcName   -FileLocation $filename -Description "AdScript1" -Remarks "Test Remarks" -Status 0 -MachineName $machineName.ToUpper() -Predecessor $Guid

#add code to wait till final step is over...

$WindowsServer2008R2SP1WithSQL2012="fb83b3509582419d99629ce476bcb5c8__Microsoft-SQL-Server-2012-Evaluation-CY13Feb-SQL11-SP1-CU2-11.0.3339.0"

# SQL Servers Service 
$StorageUriBase = "https://" + "portalvhdsfrftdk9j6z93q" + ".blob.core.windows.net/vhds/"
$SQLServersName = "SP2013-AIS-SQL" 
$SQLServersLabel = "SP2013-AIS-SQL" 
$SQLServersDescription = "SP2013 SQL Servers" 
$SQLServers = @() 
$SQLDiskSize = 100 
$SQLDataDiskLabel = "DataDisk" 
$SQLDataDiskName = "Data Disk" 
$SQLLogDiskLabel = "LogDisk"
 $SQLLogDiskName = "Log Disk"
  $SQLTempDbDiskLabel = "TempDbDisk" 
  $SQLTempDbDiskName = "TempDb Disk" 
  $SQLServersArray = (1) 
  Foreach ($SQLServer in $SQLServersArray)
   { # SQLn
    $SQLnDataDiskMediaLocation = $StorageUriBase + "sp2013sql" + $SQLServer + "datadisk01.vhd"
     $SQLnLogDiskMediaLocation = $StorageUriBase + "sp2013sql" + $SQLServer + "logdisk01.vhd" 
     $SQLnTempDbDiskMediaLocation = $StorageUriBase + "sp2013sql" + $SQLServer + "tempdbdisk01.vhd"
      $SQLnName = "SP2013SQL" + $SQLServer
       $SQLnLabel = "SP2013SQL" + $SQLServer
       $SQLnSize = "Large" 
       $SQLnSysDiskMediaLocation = "https://" + "portalvhdsfrftdk9j6z93q" + ".blob.core.windows.net/vhds/sp2013sql" + $SQLServer + "systemdisk01.vhd"
        $SQLnDataDiskLabel = $SQLnLabel + $SQLDataDiskLabel
         $SQLnLogDiskLabel = $SQLnLabel + $SQLLogDiskLabel
          $SQLnTempDbDiskLabel = $SQLnLabel + $SQLTempDbDiskLabel 
          $SQLn = New-AzureVMConfig -Name $SQLnName -ImageName $WindowsServer2008R2SP1WithSQL2012 -InstanceSize $SQLnSize -Label $SQLnLabel -MediaLocation $SQLnSysDiskMediaLocation | 
          Add-AzureProvisioningConfig -Windows -Password $adminPassword  |
#Add-AzureProvisioningConfig -WindowsDomain -Password $adminPassword  -Domain "corp.ais.com" -DomainUserName "corp.ais.com\SPFarm" -DomainPassword "Passw0rd" -JoinDomain "corp.ais.com" -MachineObjectOU "OU=SharePoint Farm,DC=corp,DC=air,DC=com" |
 Add-AzureDataDisk -CreateNew -DiskSizeInGB $SQLDiskSize -DiskLabel $SQLnDataDiskLabel -LUN 0 -MediaLocation $SQLnDataDiskMediaLocation | 
Add-AzureDataDisk -CreateNew -DiskSizeInGB $SQLDiskSize -DiskLabel $SQLnLogDiskLabel -LUN 1 -MediaLocation $SQLnLogDiskMediaLocation |
 Add-AzureDataDisk -CreateNew -DiskSizeInGB $SQLDiskSize -DiskLabel $SQLnTempDbDiskLabel -LUN 2 -MediaLocation $SQLnTempDbDiskMediaLocation 
 # Set-AzureSubnet $SQLSubnetName 
 $SQLServers += $SQLn 
  } 
 
 New-AzureVM  -ServiceName $cloudSvcName -VMs $SQLServers