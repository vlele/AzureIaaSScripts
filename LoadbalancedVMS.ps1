# Retrieve with Get-AzureSubscription 

$subscriptionName = 'ais'  

$storageAccountName = 'ais2'   

$subscriptionId  = '66cacb0f-a871-4b0b-a161-bd04492f956a'

$thumbPrint = '2EB9DD83557985E63FBFBBD2E7308B5093F2CAB2'

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 
$avsetwfe = 'high_availability' 
$lbsetwfe = 'load_balanced'

# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 


# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 



# Retreive with Get-AzureLocation 
$location = 'East US' 


# ExtraSmall, Small, Medium, Large, ExtraLarge
$instanceSize = 'Small' 



# Has to be a unique name. Verify with Test-AzureService
$serviceName = 'VLLBWFE3' 

Get-AzureVMImage | where { ($_.Category -eq "Microsoft")   }


# Server Name
$vmname1 = 'WFE1'
# Server Name
$vmname2 = 'WFE2'

$WFE1 = New-AzureVMConfig -Name $vmname1 -ImageName 'a699494373c04fc0bc8f2bb1389d6106__Win2K8R2SP1-Datacenter-201212.01-en.us-30GB.vhd' -InstanceSize 'Small' -AvailabilitySetName  $avsetwfe |
	
    Add-AzureProvisioningConfig	-Windows -Password "Devise#!!!" |			
	Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp |
    Add-AzureEndpoint -Name 'http' -LocalPort 80 -Protocol tcp -LBSetName $lbsetwfe -ProbePort 80 -ProbeProtocol http -ProbePath '/heathCheck/check.aspx' -PublicPort 80 

$WFE2 = New-AzureVMConfig -Name $vmname2 -ImageName 'a699494373c04fc0bc8f2bb1389d6106__Win2K8R2SP1-Datacenter-201212.01-en.us-30GB.vhd' -InstanceSize 'Small' -AvailabilitySetName  $avsetwfe |
	

    Add-AzureProvisioningConfig	-Windows -Password "Devise#!!!" |					
	Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp |
    Add-AzureEndpoint -Name 'http' -LocalPort 80 -Protocol tcp -LBSetName $lbsetwfe -ProbePort 80 -ProbeProtocol http -ProbePath '/heathCheck/check.aspx' -PublicPort 80 

New-AzureVM -ServiceName $serviceName -Location $location -VMs $WFE1, $WFE2  					

