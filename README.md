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

### Agent http requests:

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

