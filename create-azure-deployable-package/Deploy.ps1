param (
    [Parameter(HelpMessage="Provide patch to the first  publish profile")][string]$firstPublishProfilePath,
    # [Parameter(HelpMessage="Provide patch to the second publish profile")][string]$mfrWebPublishProfilePath
)


if(![string]::IsNullOrEmpty($firstPublishProfilePath) -And ![System.IO.File]::Exists($firstPublishProfilePath)){
   throw "File $firstPublishProfilePath does not exist!"
}



function Publish($package, $publishProfile)
{
	& 'WAWSDeploy/WAWSDeploy.exe' $package $publishProfile /v /AppOffline /d
}

$now = Get-Date -f yyyyMMdd-HHmmss;

Start-Transcript -Path "deploy-package-$now.log" -NoClobber


if(![string]::IsNullOrEmpty($firstPublishProfilePath)){
	echo "Starting publishing Payments Web Api / $firstPublishProfilePath"
	Publish  dist/paymentswebapi $firstPublishProfilePath
}



Stop-Transcript