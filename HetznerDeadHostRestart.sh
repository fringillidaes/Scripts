#!/bin/bash

# This script will ping your hetzner server, If it does not respond within 5 seconds it will issue a restart via the hetzner robot api.

# Log file gets created in the directory the script is in. 
# And fill in the variables with the settings applicable to your server.
# Can Find netcat binarys here https://github.com/H74N/netcat-binaries
netcatbinary=""
port=""
ip=""
# To genenerate login https://robot.your-server.de/preferences/index and open webservice to create credentials to authenticate
login="user:password"

if $netcatbinary -z $ip $port -w 5 &> /dev/null
then
  echo "Host server is up. ~~~ `date`" >> hetz.log
  echo -e "-------" >> hetz.log
else
  echo -e "-------" >> hetz.log
  echo "Host server is down, Issuing hw and power reset. ~~~ `date`" >> hetz.log
  curl -sS -u "$login" https://robot-ws.your-server.de/reset/$ip -d type=hw >> hetz.log
  sleep 15
  echo -e "-" >> hetz.log
  sleep 15
  curl -sS -u "$login" https://robot-ws.your-server.de/reset/$ip -d type=sw >> hetz.log
  sleep 2
  echo -e "-------" >> hetz.log
fi
