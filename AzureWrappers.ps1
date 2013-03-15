 #todo create a powershell commandlet instead of referencing the dll
 ##
 ##
 ##
 Function UploadFileToBlob($fullFilePath, $blobContainerName,$blobRef )
 {
 
 Add-Type -Path "C:\Program Files\Microsoft SDKs\Windows Azure\.NET SDK\2012-10\ref\Microsoft.WindowsAzure.StorageClient.dll"
 $requestTimeoutInSeconds = 600;
 $cloudStorageAccountNameAndKey = new-object Microsoft.WindowsAzure.StorageCredentialsAccountAndKey($blobStorageAccountName, $blobStorageAccountKey);
 $cloudStorageAccount = new-object Microsoft.WindowsAzure.CloudStorageAccount($cloudStorageAccountNameAndKey, $true);
 $cloudBlobClient = [Microsoft.WindowsAzure.StorageClient.CloudStorageAccountStorageClientExtensions]::CreateCloudBlobClient($cloudStorageAccount)
 $blobContainer = $cloudBlobClient.GetContainerReference($blobContainerName);
 $blobContainer.CreateIfNotExist();
 $blockBlob = $blobContainer.GetBlockBlobReference($blobRef);
 $blobRequestOptions = new-object Microsoft.WindowsAzure.StorageClient.BlobRequestOptions;
 $blobRequestOptions.Timeout = [TimeSpan]::FromSeconds($requestTimeoutInSeconds);
 $blockBlob.UploadFile($fullFilePath, $blobRequestOptions);
 }