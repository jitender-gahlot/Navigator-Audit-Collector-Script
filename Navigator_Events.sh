#!/bin/bash

##### JQ ang FIGLET packages must be installed to execute this script ##### 
#JQ : https://stedolan.github.io/jq/download/
#Figlet: http://www.figlet.org

Navigator_HOST=http://nightly59-1.gce.cloudera.com # change it accordingly
Navigator_PORT=7187
log_limit=10000 # Number of events you need to get at a time, maximum is 10000
offset=0
count=0
results=0
figlet $count
startTime=1484900396000 # change it accordingly
endTime=1485410299000 # change it accordingly

while [ $count -ge $results ]; do
  count=$(curl --silent -u admin:admin $Navigator_HOST:$Navigator_PORT/api/v9/audits/\?query\=service%3D%3D\*\&startTime\=$startTime\&endTime\=$endTime\&limit\=$log_limit\&offset\=$offset\&format\=JSON\&attachment\=false | jq '. | length')
  results=$(curl --silent   -u admin:admin $Navigator_HOST:$Navigator_PORT/api/v9/audits/\?query\=service%3D%3D\*\&startTime\=$startTime\&endTime\=$endTime\&limit\=$log_limit\&offset\=$offset\&format\=JSON\&attachment\=false | jq '. | length')
  echo "Fetching events, please wait..."
  curl --silent   -u admin:admin $Navigator_HOST:$Navigator_PORT/api/v9/audits/\?query\=service%3D%3D\*\&startTime\=$startTime\&endTime\=$endTime\&limit\=$log_limit\&offset\=$offset\&format\=JSON\&attachment\=false
  offset=$(($offset+1000))
  figlet $offset
  if [ $results -lt $log_limit ]; then
   break;
  fi;
done
echo fininsh
