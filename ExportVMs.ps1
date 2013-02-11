# -------------------------------------------------------------------------------------------------
 # ExportVms - This script exports the existing VM configuration
 
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

Get-AzureVM -ServiceName $serviceName | foreach {
    $path = $ExportPath + $_.Name + '.xml'
    Export-AzureVM -ServiceName $serviceName -Name $_.Name -Path $path
}
# Faster way of removing all VMs while keeping the cloud service/DNS name

Remove-AzureDeployment -ServiceName $serviceName -Slot Production -Force


#$myVMs = @("az-ad-01","az-sql-01","az-sql-02","az-web-01","az-web-02")
#Foreach ( $myVM in $myVMs ) { 
#Stop-AzureVM -ServiceName $myVM -Name $myVM -Verbose
#$ExportPath = "C:\temp\ExportVMs\ExportAzureVM-$myVM.xml" 
##Export-AzureVM -ServiceName $myVM -name $myVM -Path $ExportPath -Verbose
#Remove-AzureVM -ServiceName $myVM -name $myVM -Verbose
#} 


