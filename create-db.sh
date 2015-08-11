#!/bin/bash

infoFile="output/info.txt"
rm -f $infoFile
echo $(date +"%Y-%m-%d %H:%M:%S") start >> $infoFile
chown 1000:1000 $infoFile

# Get apt sources list, update, and install needed stuff
echo "Updating and installing basics..."
DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get -y dist-upgrade && apt-get -y install unzip build-essential wget ftp

# Download and unzip project from GitHub
echo "Downloading and unzipping project from GitHub..."
wget https://github.com/Markus-Go/ip-countryside/archive/master.zip
unzip master.zip
cd ip-countryside-master

# Build program
echo "Build the tool to process raw data to desired output..."
make

# Get raw data to process
echo "Get required raw data to create desired output..."
./getDBs.sh

# Create "ip2country.db" from downloaded raw data
echo "Start tool to process raw data and create desired output..."
./createDb

# Change owner of result file "ip2country.db" to standard user
echo "Changing owner of output file from root user to standard user..."
chown 1000:1000 ip2country.db

# Move result to ouput dir (this should be mapped to a dir on the host, as the container will be desposed after existing)
echo "Moving the result file to the "output" subdirectory (should be mapped to a dir on the host, as the whole container will be deleted after finishing this script)..."
mv ip2country.db ../output/ip2country.db

# Adding some details to info file
echo "Adding some details to info file..."
md5sum ../output/ip2country.db >> ../$infoFile
echo "" >> ../$infoFile
wc -l ../output/ip2country.db >> ../$infoFile
echo "" >> ../$infoFile
ls -la *-latest* >> ../$infoFile
echo "" >> ../$infoFile
ls -la *.db.inetnum >> ../$infoFile
echo "" >> ../$infoFile
head *-latest* >> ../$infoFile
echo "" >> ../$infoFile
head *.db.inetnum >> ../$infoFile
echo "" >> ../$infoFile
echo $(date +"%Y-%m-%d %H:%M:%S") stop >> ../$infoFile

# Done
echo "We're done. Exit."
