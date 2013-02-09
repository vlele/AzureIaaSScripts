# -------------------------------------------------------------------------------------------------
 # ImportVms - This script imports the existing VM configuration
 
 #
 # To do - 
 #         1) Create a file within a subfolder called "include" and add a script  
 #            file called SubscriptionInfo.ps1 with the following variables 
 # 
 #            $subscriptionName
 #            $storageAccountName
 #            $subscriptionId
 #            $storageAccountName
 #            $thumbPrint 
 #            $vnetName ( needed for import) 
 #         
 #         2) Specify appropriate values for variables $myCert, $location, $instanceSize, $serviceName
 #
 # -------------------------------------------------------------------------------------------------

# include the subscription info
. C:\Users\vishwas.lele\Documents\MyScripts\include\SubscriptionInfo.ps1

# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 
# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 

$myVMs = @("az-sql-01","az-sql-02","az-web-01","az-web-02")
Foreach ( $myVM in $myVMs ) 
{ 

    Stop-AzureVM -ServiceName $myVM -Name $myVM -Verbose
}

$myVMs = @("az-ad-01","az-sql-01","az-sql-02","az-web-01","az-web-02")
Foreach ( $myVM in $myVMs ) 
{ 
    $ExportPath = "C:\Users\vishwas.lele\Documents\MyScripts\config\$myVM-config.xml"     
    Import-AzureVM -Path $ExportPath | New-AzureVM -ServiceName $myVM -VNetName $vnetName 
    Start-AzureVM -ServiceName $myVM -name $myVM 
}




