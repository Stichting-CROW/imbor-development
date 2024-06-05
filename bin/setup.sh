#!/usr/bin/env bash

docker start graphdb-imbor-pipeline ||
    docker run \
        -d \
        -p 0.0.0.0:7200:7200 \
        --name graphdb-imbor-pipeline \
        -t ontotext/graphdb:10.6.3

until [ "$(docker inspect -f {{.State.Running}} graphdb-imbor-pipeline)"=="true" ]; do
    sleep 0.1
done

curl \
    --location \
    -X POST \
    --form "config=@src/graphdb/graphdb-config.ttl" \
    "http://localhost:7200/rest/repositories"

npm install --global @rdmr-eu/rdfjs-source-msaccess
npm install --global @rdmr-eu/sparql-query-runner
