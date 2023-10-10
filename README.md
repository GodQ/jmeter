# jmeter

## Description

Jmeter as a service

## Software Architecture

One master node and multiple worker node. Every worker node is a jmeter server and master node is a client.
Master node will run a go-rest-agent service to act as a rest server. 

## Installation

1. Docker

- Use volumn to pass jmeter jmx project, refer to examples/docker-service-volumn.sh

- Use git url to fetch jmeter jmx project, refer to examples/docker-service-git.sh

2. k8s 

- todo

## Instructions

### Jmeter project

A full jmeter test project should include two folders:

- jmeter folder, include all the jmx files and csv files, it is required.

- lib folder, include all the customized plugin jar files, it is optional. 

### Required env settings for containers

#### Worker node

Worker node should set the env variables following:

```
        -e ROLE=worker \
        -v $local_jmeter_src:$project_dir \
        -e PROJECT_DIR=$project_dir \
        -e JMX_DIR=jmx \
        -e LIB_EXT_DIR=lib \
```
The default value:

|env|default value| description|
|---|---|---|
|JMETER_DIR |/jmeter |jmeter bin folder|
|PROJECT_DIR   |/project   |jmeter project folder|
|JMX_DIR |jmx | jmx relative folder in PROJECT_DIR |
|LIB_EXT_DIR |lib | lib ext relative folder in PROJECT_DIR |
|ROLE |worker | should in [worker, master]|

#### Master node

Master node should set the env variables as the worker node, but "ROLE" should be set "master".



### Agent http requests

1. create task:


```
  curl -L -XPOST '127.0.0.1:5000/api/v1/tasks' -H 'Content-Type: application/json' -d '{"command": "$JMETER_DIR/bin/jmeter -Jserver.rmi.ssl.disable=true -n -t $JMX_DIR/csv_test.jmx -l result.txt -f -e -o report_dir -R jmeter-worker-1,jmeter-worker-0","timeout_seconds": 3600}'

```

2. list tasks:


```
  curl -L -XGET '127.0.0.1:5000/api/v1/tasks'

```

3. get result file:


```
  curl -L '127.0.0.1:5000/api/v1/file?file_path=/project/result.txt' -H 'Content-Type: application/x-www-form-urlencoded'

```

