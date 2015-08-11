#!/bin/bash

# Check if docker image named "ip-countryside" already exists. If not, create it.
if [ -z $(sudo docker images | awk '{print $1}' | grep -Fx ip-countryside) ]; then
  echo Docker image ip-countryside does not exist yet. Creating it now.
  sudo docker build -t ip-countryside .
fi

echo "Starting creation of DB in throwaway Ubuntu container with output dir mapped to data dir"
echo " - will download everything, and create DB in internal dir /usr/src/project"
echo " - after DB is created, will write output to internal dir  /usr/src/project/output"
echo "Note: The '/usr/src/project/output' directory is mounted to the subdirectory 'output' of the current dir."
echo "      After throwaway docker container ended, the result file 'ip2country.db' will be there (and the container will be gone)."
mkdir -p output
sudo docker run -it --rm -v $(pwd)/output:/usr/src/project/output -w /usr/src/project ip-countryside
