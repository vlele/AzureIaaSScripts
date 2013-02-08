# create a virtual network
# Create a virtual machine az-ad-01
# Create a virtual machine az-web-01
# Create a virtual machine az-web-02
# Create a virtual machine az-sql-01
# Create a virtual machine az-sql-02
#
$cloudSvcName = 'az-ad-01'
$SubscriptionName = '3-Month Free Trial'
$SubscriptionId =    '91ec5866-f010-497f-a22e-63f265a20c86'
$storageAccountName = 'azos' 
Import-AzurePublishSettingsFile 'C:\Users\vishwas.lele\Documents\MyScripts\settings.publishsettings'
Set-AzureSubscription -SubscriptionName $SubscriptionName -CurrentStorageAccount $storageAccountName
$vmname = 'az-ad-01' 
Get-AzureVMImage | where { ($_.Category -eq "Microsoft")   }
Export-AzureVM -ServiceName $cloudSvcName -Name $vmname -Path 'c:\Temp\mytestvm1-config.xml' 



