# -------------------------------------------------------------------------------------------------
 # ImportVms - This script imports the existing VM configuration
 
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
$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 

# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 
# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 



$ExportPath = "C:\temp\ExportVMs\"

$vms = @()
Get-ChildItem $ExportPath | foreach {
	$path = $ExportPath + $_
	$vms += Import-AzureVM -Path $path
}
New-AzureVM -ServiceName $serviceName -VMs $vms

#$myVMs = @("az-sql-01","az-sql-02","az-web-01","az-web-02")
#Foreach ( $myVM in $myVMs ) 
#{ 
#
#    Stop-AzureVM -ServiceName $myVM -Name $myVM -Verbose
#}
#
#$vnetName = 'IAAS-DC' 
#$myVMs = @("az-ad-01","az-sql-01","az-sql-02","az-web-01","az-web-02")
#Foreach ( $myVM in $myVMs ) 
#{ 
#    $ExportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$myVM-config.xml"     
#    Import-AzureVM -Path $ExportPath | New-AzureVM -ServiceName $myVM -VNetName $vnetName 
#    Start-AzureVM -ServiceName $myVM -name $myVM 
#}




