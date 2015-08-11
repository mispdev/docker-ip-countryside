docker-ip-countryside
=====================

What it is
----------

You want to map IP adresses to a country? You want that information to be current? You want that information to be derived directly from the official registries AFRINIC, APNIC, ARIN, LACNIC and RIPE? You want to be able to create that mapping DB on your own and use it any way you want, e.g. to import it to a RBDMS and do as much queries as you like, instead of doing costly REST API queries to questionable "free" services?

This project provides you with a simple bash script that uses [Docker](https://www.docker.com/) to pull and use another GitHub project to create a file you can use to do geolocation of IPv4 addresses. The file will be compiled out of the current IP assignment information available from the official registries AFRINIC, APNIC, ARIN, LACNIC and RIPE, extended by WHOIS information of RIPE and APNIC (if needed).

In short: This project enables users of [Docker](https://www.docker.com/) to run the project [ip-countryside](https://github.com/Markus-Go/ip-countryside) of [Markus-Go](https://github.com/Markus-Go) within a docker container.

Compatibility: Just tested with Ubuntu 14.04. Your mileage may vary.

How to use it
-------------

If you have installed [Docker](https://www.docker.com/) already, just download this project, change to the project directory, and execute:

`./dockerCreateIPCountrysideDB.sh`

After everything is finished (this may take a while), please find the resulting `ìp2country.db` in folder `output`.

Note: Make sure you have at least about 4 GB of free disk space left before running the bash script, as the downloaded data and temp files will consume some space.

How it works
------------

When starting `dockerCreateIPCountrysideDB.sh`, it will check if a docker image with the name `ip-countryside` does already exist (at first start it should not). If it does not exist yet, it will create it according to the dockerfile `Dockerfile` contained in this project.

After that the subdirectory `output` will be created (if it does not exist yet) to store the result file `ip2country.db`.

Now a throwaway docker container of the created docker image `ip-countryside` is started. By default the bash script `create-db.sh` will be executed from the internal directory `/usr/src/project`. It will
 - Update Ubuntu base image
 - Download latest version of "ip-countryside" project from GitHub
 - Build project
 - Download raw data using `getDBs.sh` of project
 - Process raw data using `createDb` (built from project)
 - Move result file `ip2country.db` to output directory (that is mapped to host)
 - Add file `info.txt` to output directory (which includes some information about processed files)

Finally the docker container ends, and is automatically disposed. The only remainings are in subdirectory `output`.

Status and license
------------------

The project is just a "docker wrapper" I created around the project [ip-countryside](https://github.com/Markus-Go/ip-countryside) of [Markus-Go](https://github.com/Markus-Go) to get the resulting `ip2country.db` for geolocation of IP addresses easily. If you find this useful, then just use it (no warranties attached - use at your own risk). This docker wrapper is licensed under [Apache 2 license](http://www.apache.org/licenses/LICENSE-2.0) (not affecting license of wrapped project). Any contributions you want to make to this project need to be provided under the same license or will be rejected.
