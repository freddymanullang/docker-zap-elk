#!/bin/bash
INPUT_FILE="$PWD/$1"
docker run --name "zap" -e LC_ALL=C.UTF-8 -e LANG=C.UTF-8 -u zap -p 2375:2375 -d owasp/zap2docker-weekly zap.sh -daemon -port 2375 -host 127.0.0.1 -config api.disablekey=true -config scanner.attackOnStart=true -config view.mode=attack -config connection.dnsTtlSuccessfulQueries=-1 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true
parallel ./run-docker.sh < $INPUT_FILE
docker stop zap
docker rm -f zap