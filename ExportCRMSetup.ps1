﻿# -------------------------------------------------------------------------------------------------
 # ExportCRMSetup - This script exports the existing VM configuration
 
 #
 # To do - 
 #         
 #         1) Specify appropriate values for variables $myCert, $location, $instanceSize, $serviceName
 #
 # -------------------------------------------------------------------------------------------------

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	

CheckReqVariables


# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 
# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 


$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 

#ais-crm-ad
$cloudService = "ais-crm-dc"
$vm = "ais-crm-ad"
Stop-AzureVM -ServiceName $cloudService -Name $vm -Verbose
$ExportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$vm-config.xml" 
Export-AzureVM -ServiceName $cloudService -name $vm -Path $ExportPath -Verbose
Remove-AzureVM -ServiceName $cloudService -name $vm -Verbose

#ais-crm-sql
$cloudService = "ais-crm-sql"
$vm = "ais-crm-sql"
Stop-AzureVM -ServiceName $cloudService -Name $vm -Verbose
$ExportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$vm-config.xml" 
Export-AzureVM -ServiceName $cloudService -name $vm -Path $ExportPath -Verbose
Remove-AzureVM -ServiceName $cloudService -name $vm -Verbose

# Note VMs ais-crm-web1 and ais-crm-web3 are part of the same cloud service
#ais-crm-web1
$cloudService = "ais-crm-web1"
$vm = "ais-crm-web1"
Stop-AzureVM -ServiceName $cloudService -Name $vm -Verbose
$ExportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$vm-config.xml" 
Export-AzureVM -ServiceName $cloudService -name $vm -Path $ExportPath -Verbose
Remove-AzureVM -ServiceName $cloudService -name $vm -Verbose

#ais-crm-web3
$cloudService = "ais-crm-web1"
$vm = "ais-crm-web3"
Stop-AzureVM -ServiceName $cloudService -Name $vm -Verbose
$ExportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$myVM-config.xml" 
Export-AzureVM -ServiceName $cloudService -name $vm -Path $ExportPath -Verbose
Remove-AzureVM -ServiceName $cloudService -name $vm -Verbose

