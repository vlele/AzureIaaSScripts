 # -------------------------------------------------------------------------------------------------
 # LoadBalancedVMs - This script creates two virtual machines with load 
 #                    balanced end points. 
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
 #         
 #         2) Specify appropriate values for variables $myCert, $location, $instanceSize, $serviceName
 #
 # -------------------------------------------------------------------------------------------------

# include the subscription info
. C:\Users\vishwas.lele\Documents\MyScripts\include\SubscriptionInfo.ps1

$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint 

# Retreive with Get-AzureLocation 
$location = 'East US' 

# ExtraSmall, Small, Medium, Large, ExtraLarge
$instanceSize = 'Small' 

# Has to be a unique name. Verify with Test-AzureService
$serviceName = 'VLLBWFE3' 

# Server Name
$vmname1 = 'WFE1'

# Server Name
$vmname2 = 'WFE2'

# Availability Set
$avsetwfe = 'AV1'

# Load Balanced 
$lbsetwfe = 'LBSET1'
  
# Specify the storage account location to store the newly created VH
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccount   $storageAccountName -SubscriptionID $subscriptionId -Certificate $myCert
 
# Select the correct subscription (allows multiple subscription support) 
Select-AzureSubscription -SubscriptionName $subscriptionName 

# Get the list of images
#Get-AzureVMImage | where { ($_.Category -eq "Microsoft")   }


$WFE1 = New-AzureVMConfig -Name $vmname1 -ImageName 'a699494373c04fc0bc8f2bb1389d6106__Win2K8R2SP1-Datacenter-201212.01-en.us-30GB.vhd' -InstanceSize 'Small' -AvailabilitySetName  $avsetwfe |
	
    Add-AzureProvisioningConfig	-Windows -Password $password |			
	Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp |
    Add-AzureEndpoint -Name 'http' -LocalPort 80 -Protocol tcp -LBSetName $lbsetwfe -ProbePort 80 -ProbeProtocol http -ProbePath '/heathCheck/check.aspx' -PublicPort 80 

$WFE2 = New-AzureVMConfig -Name $vmname2 -ImageName 'a699494373c04fc0bc8f2bb1389d6106__Win2K8R2SP1-Datacenter-201212.01-en.us-30GB.vhd' -InstanceSize 'Small' -AvailabilitySetName  $avsetwfe |
	

    Add-AzureProvisioningConfig	-Windows -Password $password |					
	Add-AzureEndpoint -Name 'Remote Desktop' -LocalPort 3389 -Protocol tcp |
    Add-AzureEndpoint -Name 'http' -LocalPort 80 -Protocol tcp -LBSetName $lbsetwfe -ProbePort 80 -ProbeProtocol http -ProbePath '/heathCheck/check.aspx' -PublicPort 80 

New-AzureVM -ServiceName $serviceName -Location $location -VMs $WFE1, $WFE2  					

