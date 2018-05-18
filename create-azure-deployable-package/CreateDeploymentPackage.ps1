param (
    [Parameter(Mandatory=$true, HelpMessage ="Provide version of the the package")][string]$version,
    [Parameter(Mandatory=$true, HelpMessage="Provide enviroment (DEV, QA, PROD)")][string]$enviroment,
    [Parameter(Mandatory=$true, HelpMessage="Provide information if package should be compressed")][ValidateSet("true", "false")][string]$zipPackage 
)

function BuildAndCreate($configType, $packagePublishProfile, $version, $projectName, $project)
{
	Build  $configType $packagePublishProfile $project
	
	$YourDirToCompress="Artifacts\$projectName"
	$dist= "$version\dist\$projectName"
	
	Copy-Item -Path $YourDirToCompress -Filter "*" -Recurse -Destination $dist -Container
	Remove-Item Artifacts\$projectName -Force -Recurse


}

function ZipFiles($YourDirToCompress, $ZipFileResult)
{
	Get-ChildItem $YourDirToCompress  | Compress-Archive -DestinationPath $ZipFileResult -Update 
}

function Build($configType, $packagePublishProfile, $project)
{	 
	$msbuild = "& 'C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe'"

	$options = "/p:DeployOnBuild=true /p:PublishProfile=$packagePublishProfile /p:VisualStudioVersion=14.0 /p:Configuration=$configType"
	
	$build = $msbuild + " $project " + $options
	
	echo $build
	Invoke-Expression $build
}

switch($zipPackage.ToLower()) {
    "true" { $zipPackage = $true }
    default { $zipPackage = $false }
}

echo "Provided parameters : version = $version, enviroment = $enviroment, zipPackage = $zipPackage"

Start-Transcript -Path "$version\create-package.log" -NoClobber


echo "Preparing package"
New-Item -ItemType Directory -Force -Path "$version/dist"

echo "restoring packagaes"
..\.nuget\nuget.exe restore ..\Solution.sln
echo "packages restored"

Copy-Item "Deploy.ps1" "$version\Deploy.ps1"

echo "Starting building 1st csproj"
BuildAndCreate  $enviroment  'ToPackage' $version 'paymentswebapi' '..\Path\Project.csproj'


echo "Finializing package"
Remove-Item Artifacts\ -Force -Recurse

Copy-Item -Path "WAWSDeploy" -Filter "*" -Recurse -Destination "$version" -Container

Stop-Transcript

if($zipPackage -eq $true)
{
	ZipFiles "$version" "$version.zip"
	Remove-Item "$version"  -Force -Recurse
}

