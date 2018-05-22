# useful-scripts

some useful scripts 

1) create-azure-deployable-package - build package which can be later on deployed to azure

- To create deployment package use following command 
.\CreateDeploymentPackage.ps1 <version name / number>  <configuration name>
ex : 
.\CreateDeploymentPackage.ps1 mobile-payments-1.0.0 DEV

- Zip deployment package will be created 
- Zip package should be sent to the client
- Client has to add publish profile localization in the config file 
- And call .\Deploy.ps1 script .\Deploy.ps1 	-firstPublishProfilePath "Path.PublishSettings" 
--
To deploy package to azure we are using https://github.com/davidebbo/WAWSDeploy

2) multiple-docker-composes - this convenience powershell script can be used to start up multiple services using a single command

All console terminals will be opened in the ConEmu https://conemu.github.io/  (has to be installed).

Add ConEmu64 to the path (if not added).




