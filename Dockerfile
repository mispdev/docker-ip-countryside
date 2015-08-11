# Run ip-countryside https://github.com/Markus-Go/ip-countryside
FROM ubuntu:14.04

# Create directories
#  - /usr/src/project        : Will download "ip-countryside" master from GitHub to this directoy and execute it
#  - /usr/src/project/output : After creation process, the resulting "ip2country.db" will be moved here
# Note: Intended use is to map "/usr/src/project/output" to a directory on the host (to keep "ip2country.db") and throw container away
RUN mkdir /usr/src/project && mkdir /usr/src/project/output

# Add script that will arrange everything (download project, compile, execute, move result to "output")
ADD create-db.sh /usr/src/project/create-db.sh
RUN chmod +x /usr/src/project/create-db.sh

# At container start, just execute our script
CMD ["/usr/src/project/create-db.sh"]
