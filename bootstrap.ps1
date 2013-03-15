cls

$rootpath = 'C:\BootStrap\'
$manifest = 'C:\BootStrap\Working\manifest.xml'
$workingdir = 'C:\BootStrap\Working\'
$downloaddir = 'C:\BootStrap\Working\config1.zip'
$packageprefixpackagesource = 'http://portalvhdsfrftdk9j6z93q.blob.core.windows.net/blob/'

function GetPayload()
{
$cloudServiceName =  ipconfig | where-object {$_ –match "Connection-specific DNS Suffix"} | foreach-object{$_.Split(".")[2]} |Select -First 1
$machineName= get-content env:computername
$packagesource = $packageprefixpackagesource+ $cloudServiceName +"_"+$machineName+"_config.zip"
    $retries = 5
	while($retries -gt 0)
	{
		CheckFolder $workingdir
	    try {
		    $wc = New-Object System.Net.WebClient
		    $wc.DownloadFile($packagesource, $downloaddir)
			break
	     } 
	     catch [System.Net.WebException] {
		    # $_ is set to the ErrorRecord of the exception
	        if ($_.Exception.InnerException) {
	     	   $_.Exception.InnerException.Message | Out-File c:\BootStrap\error.txt -Append
	        } else {
	           $_.Exception.Message | Out-File c:\BootStrap\error.txt -Append
	        }
			Start-Sleep -Seconds 15
			$retries = $retries - 1
	     }
	 }
     UnzipFileTo $downloaddir $workingdir
}

function BootStrapVM()
{
  if((Test-Path HKLM:\Software\VMBootStrap) -eq $true)
  {
     Write-Host "Already Ran"
	 return
  }

  [xml] $manifest = Get-Content $manifest
  $counter = 0
  $manifest.StartupManifest.Items.Item | foreach { 
	$action = $_.action 
	$path = $_."#text"
	$target = $_.target 
	$sourcefullpath = $workingdir + $path
	
	switch($action)
	{
	   "execute" {
		  Write-Host "Executing command: " $sourcefullpath
		  ExecuteCommand $sourcefullpath
	   }
	   "unzip" {
		  $sourcefullpath = $workingdir + $path
		  Write-Host "Unzipping " $sourcefullpath " to " $target 
	      UnzipFileTo $sourcefullpath $target
	   }
	   
	}
	 
  }
  New-Item -Path HKLM:\Software -Name VMBootStrap –Force | Out-Null
  Set-Item -Path HKLM:\Software\VMBootStrap -Value "ran" | Out-Null
}

function ExecuteCommand($commandpath)
{
	& $commandpath
}

function UnzipFileTo($sourcepath, $destinationpath)
{
	CheckFolder $destinationpath
	$shell_app = new-object -com shell.application
	$zip_file = $shell_app.namespace($sourcepath)
	$destination = $shell_app.namespace($destinationpath)
	$destination.Copyhere($zip_file.items(), 16)
}

function CheckFolder($path)
{
	if((Test-Path $path) -eq $false)
	{
   		New-Item -ItemType directory -Path $path -Force | Out-Null
	}
}
GetPayload
BootStrapVM
