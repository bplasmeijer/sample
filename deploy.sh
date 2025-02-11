
#!/bin/bash

# Source the .secrets file
if [ -f .secrets ]; then
  source .secrets
else
  echo ".secrets file not found!"
  echo "use github secrets to store the following variables:"
  echo "DOCKER_USERNAME=your_docker_username"
  echo "DOCKER_PASSWORD=your_docker_password"
fi

echo "$DOCKER_USERNAME"

for dir in deployments/*/
do
    if [[ $dir == *"package"* ]]; then
        echo "Skipping $dir"
        continue
    fi
    echo "Deploying $dir"
    app=${dir#deployments/}
    app=${app%/}

    echo "Deploying $dir on $app"

    cp -r deployments/package/py/deployment.yaml deployments/$app/deployment.yaml

    sed -i "s/APP_NAME/$app/g" deployments/$app/deployment.yaml
    sed -i "s/APP_IMAGE/$DOCKER_USERNAME\/$app:latest/g" deployments/$app/deployment.yaml
    
    cpu_min=$(jq -r '.resources.cpu.min' deployments/$app/config.json)
    cpu_max=$(jq -r '.resources.cpu.max' deployments/$app/config.json)
    memory_min=$(jq -r '.resources.memory.min' deployments/$app/config.json)
    memory_max=$(jq -r '.resources.memory.max' deployments/$app/config.json)

    sed -i "s/CPU_MIN/$cpu_min/g" deployments/$app/deployment.yaml
    sed -i "s/CPU_MAX/$cpu_max/g" deployments/$app/deployment.yaml
    sed -i "s/MEMORY_MIN/$memory_min/g" deployments/$app/deployment.yaml
    sed -i "s/MEMORY_MAX/$memory_max/g" deployments/$app/deployment.yaml   

    host=$(jq -r '.ingress[0].host' deployments/$app/config.json)
    sed -i "s/HOST/$host/g" deployments/$app/deployment.yaml

    echo "HOST: $host"		

    kubectl apply -f deployments/$app/deployment.yaml --dry-run=client -o yaml > manifests/$app.yaml
done