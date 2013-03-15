# -------------------------------------------------------------------------------------------------
 # Validation : This script validates the input arguments and some helper functions
 #
# -------------------------------------------------------------------------------------------------
Function CheckReqVariables ()
{
	#Write-Host "Inside CheckVariables"
	$found=Test-Path variable:global:subscriptionName
	IF($found -eq $false -or $subscriptionName.get_Length -eq 0)
	{
		Write-Error "SubscriptionName not found"
		exit
	}
	$found=Test-Path variable:global:subscriptionId
	IF($found -eq $false -and $subscriptionId.get_Length -eq 0)
	{
		Write-Error "subscriptionId not found"
		exit
	}
	$found=Test-Path variable:global:thumbPrint
	IF($found -eq $false -and $thumbPrint.get_Length -eq 0)
	{
		Write-Error "thumbPrint not found"
		exit
	}
	$found=Test-Path variable:global:storageAccountName
	IF($found -eq $false -and $storageAccountName.get_Length -eq 0)
	{
		Write-Error "storageAccountName not found"
		exit
	}
	$found=Test-Path variable:global:blobStorageAccountName
	IF($found -eq $false -and $blobStorageAccountName.get_Length -eq 0)
	{
		Write-Error "blobstorageAccountName not found"
		exit
	}
	
	Write-Verbose "subscriptionName: $subscriptionName"
	Write-Verbose "subscriptionId:$subscriptionId"
	Write-Verbose "thumbPrint:$thumbPrint"
	Write-Verbose "storageAccountName:$storageAccountName"
	Write-Verbose "blobstorageAccountName:$blobStorageAccountName"
}

#Changes the $serviceName to available free service name
Function ReturnUniqueSeriveName ($ServiceNameParam)
{
	$StatusParam =	Test-AzureName –Service -Name $ServiceNameParam	
	#Test-Azure Name returns true in case the Service name is not present
	
	$itr=1
	$tempServiceName=$ServiceNameParam
	while (!$StatusParam) {
	
		$tempServiceName="$ServiceNameParam$itr"
		$StatusParam =	Test-AzureName –Service -Name $tempServiceName	
		$itr=$itr+1
	}
	
	$serviceName = $tempServiceName
	Write-Host $serviceName
}