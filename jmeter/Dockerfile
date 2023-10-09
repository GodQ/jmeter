# FROM golang:1.20.5 as builder
# COPY . /agent
# WORKDIR /agent
# RUN git clone https://github.com/GodQ/go-rest-agent.git \
#     && cd go-rest-agent \
#     && go build -o /agent/agent \
#     && ls /agent



FROM openjdk:22-jdk-slim

# https://jmeter.apache.org/usermanual/remote-test.html

ENV JMETER_VERSION 5.6.2
ENV JMETER_DIR "/jmeter"
# need to overwrite if use git, example: https://gitlab.com/godq/jmeter_test.git
ENV SOURCE_GIT_URL "" 
# user should mount volumn to this folder if not use git
ENV PROJECT_DIR "/project"
# default jmx dir <jmeter project>/jmeter, need to overwrite
ENV JMX_DIR "jmx"
# default lib ext dir <jmeter project>/lib, need to overwrite
ENV LIB_EXT_DIR "lib"
# worker for worker node, master for master node
ENV ROLE=worker
# go-rest-agent port, need to overwrite
ENV AGENT_PORT 80

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get install -y zip git curl wget net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -kv https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O \
    && tar zxvf apache-jmeter-${JMETER_VERSION}.tgz -C /tmp \
    && mv /tmp/apache-jmeter-${JMETER_VERSION} $JMETER_DIR \
    && rm -f apache-jmeter-${JMETER_VERSION}.tgz

EXPOSE 1099
EXPOSE ${AGENT_PORT}

WORKDIR ${PROJECT_DIR}

# COPY --from=builder /agent/agent .
RUN wget https://github.com/GodQ/go-rest-agent/releases/download/1.0.1/agent_linux_amd64 -O $JMETER_DIR/agent \
    && chmod +x $JMETER_DIR/agent
COPY start.sh $JMETER_DIR

# Default command
CMD bash $JMETER_DIR/start.sh
