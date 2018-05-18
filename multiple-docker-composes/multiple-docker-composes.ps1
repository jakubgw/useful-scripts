

function run($operation, $target) { 
    
    $Env:COMPOSE_CONVERT_WINDOWS_PATHS=1 

    $path  = "TODO"; 

    $services =  @(
          'service-1',
          'service-2',
          'service-3',		  
      )

    if($operation -eq 'clean')
    {			
      foreach ($service in $services.GetEnumerator()) {
        if($target -and $target -ne $service) {
          continue;
        }

        if(Test-Path -Path "$path/$service/node_modules"){ 
          echo "DELETING : $path/$service/node_modules"
          rm -r -fo "$path/$service/node_modules"
        }
      }
    } elseif($operation -eq 'start')
    {			
      foreach ($service in $services.GetEnumerator()) {	
        if($target -and $target -ne $service) {
          continue;
        }

        if(Test-Path -Path "$path/$service") { 
          $command = [string]::Format("docker-compose exec {0} bash -c ""npm run dev:start""", $service) 
          ConEmu64.exe -Reuse  /dir "$path/$service" /config "shell"  /run "title '$service' & $command & pause"
          # Do not undestand it, but if we run all services in the same moment npm run crashes.. 
          Start-Sleep -s 6
        }
      }
    } elseif($operation -eq 'down')
    {
      foreach ($service in $services.GetEnumerator()) {

        if($target -and $target -ne $service) {
          continue;
        }

        if(Test-Path -Path "$path/$service"){ 
          ConEmu64.exe -Reuse  /dir "$path\$service" /config "shell"  /run "title '$service' & docker-compose down & pause"
        }
      }	
    } elseif($operation -eq 'up')
    {
      foreach ($service in $services.GetEnumerator()) {	

        if($target -and $target -ne $service) {
          continue;
        }

        if(Test-Path -Path "$path/$service"){                     
          ConEmu64.exe -Reuse  /dir "$path\$service" /config "shell"  /run "title '$service' & docker-compose up -d  & pause"
        }
      }	
    } elseif($operation -eq 'connect')
    {
      foreach ($service in $services.GetEnumerator()) {	
        
        if($target -and $target -ne $service) {
          continue;
        }

        if(Test-Path -Path "$path/$service"){ 
          $command = [string]::Format("docker-compose exec {0} bash", $service) 
          ConEmu64.exe -Reuse  /dir "$path\$service" /config "shell"  /run "title '$service' & $command  & pause"
        }
      }	
    } else {
      echo "list of parameters : "
      echo "  clean - delete all nodes modules "	;
      echo "  start - run npm run dev:start for all services";
      echo "  down - docker compose down for all services"
      echo "  up - docker compose up for all services"
      echo "  connect - docker compose exec for all services"

      echo "as a second parameter you can use service name - in this case command will be called only for this one particullar service"
    }

}