#!/bin/bash
# set -x
set -e

worker_count=2
git_url=https://gitlab.com/godq/jmeter_test.git

# cleanup all existent containers
docker ps -f label=jmeter -aq | xargs docker rm -f

# i=0
links=""
nodes=""
for((i=0;i<$worker_count;i++))
do
    node_name=jmeter-worker-$i
    docker run -it -d --rm \
        -l jmeter \
        --name $node_name \
        -e ROLE=worker \
        -e SOURCE_GIT_URL=$git_url \
        -e JMX_DIR=jmx \
        -e LIB_EXT_DIR=lib \
        godq/jmeter:5.6.2
    links="$links --link $node_name"
    nodes="$node_name,$nodes"
done
nodes=${nodes%,}  # delete the last ,
docker ps | grep jmeter-worker-

echo "jmeter master command:"
echo "   bin/jmeter -Jserver.rmi.ssl.disable=true -n -t project/csv_test.jmx -l result.txt -f -e -o report_dir -R $nodes"

docker run -it --rm \
    -l jmeter \
    --name jmeter-master \
    -p 5000:80 \
    -e ROLE=master \
    -e SOURCE_GIT_URL=$git_url \
    -e JMX_DIR=jmx \
    -e LIB_EXT_DIR=lib \
    $links \
    godq/jmeter:5.6.2 \
    bash

# docker run -it -d --rm --name jmeter-master -p 5000:80 -e ROLE=master -e SOURCE_GIT_URL=$git_url -e PROJECT_DIR=jmeter -e LIB_EXT_DIR=lib "$links" godq/jmeter
