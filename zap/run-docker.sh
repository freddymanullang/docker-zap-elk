#!/bin/bash
TARGET_URL=$1
echo=$TARGET_URL
docker exec zap zap-cli -p 2375 status -t 120 && docker exec zap zap-cli -p 2375 open-url $TARGET_URL
#docker exec zap zap-cli -p 2375 spider $TARGET_URL
docker exec zap zap-cli -p 2375 active-scan --recursive $TARGET_URL
docker exec zap zap-cli -p 2375 alerts -f json -l Informational >> output.json
docker exec zap zap-cli -p 2375 report -o output.html -f html
docker exec zap zap-cli -p 2375 report -o output.xml -f xml
docker cp zap:zap/output.html ./
docker cp zap:zap/output.xml ./
cat output.json | jq -c '.[] | {"index": {"_index": "zap", "_type": "_doc", "_id": .id+.url}}, .' | curl -H 'Content-Type: application/json'  -XPOST localhost:9200/_bulk --data-binary @-
#Add the domain of the website

cat output.json | jq -c --arg domain $TARGET_URL '.[].domain=$domain | {"index": {"_index": "zap", "_type": "_doc", "_id": .id}}, .' | curl -H 'Content-Type: application/json'  -XPOST localhost:9200/_bulk --data-binary @-
