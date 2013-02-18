$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory 'Include\SubscriptionInfo.ps1')	
. (Join-Path $ScriptDirectory 'Validation.ps1')	
. (Join-Path $ScriptDirectory 'AzureWrappers.ps1')	

CheckReqVariables

UploadFileToBlob "C:\Users\Arun\Downloads\test.txt" "blob"