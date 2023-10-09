#!/bin/bash

src_dir=$PROJECT_DIR

if [ -n "$SOURCE_GIT_URL" ]; then
    echo "jmeter project will be cloned from $SOURCE_GIT_URL"
    echo "Git clone $SOURCE_GIT_URL to folder $src_dir"
    git clone "$SOURCE_GIT_URL" "$src_dir"
    if [ -z "$?" ]; then
        echo "Failed to git clone from $SOURCE_GIT_URL"
        exit 1
    fi
elif [ -d "$PROJECT_DIR" ] && [ "$(ls -A "$PROJECT_DIR")" ]; then
    echo "jmeter project will use folder $PROJECT_DIR"
else
    echo "You should mount your jmeter volumn/local folder to $PROJECT_DIR or set env SOURCE_GIT_URL if use git"
    exit 1
fi

jmx_dir=$src_dir/$JMX_DIR
lib_dir=$src_dir/$LIB_EXT_DIR

if [ ! "$(ls -A "$jmx_dir")" ]; then
        echo "The jmeter dir should not be empty"
        exit 1
fi
# cp -rf "$jmx_dir" project

if [ -d "$lib_dir" ]; then
    if [ "$(ls -A "$lib_dir")" ]; then
        echo "copy customized lib ext jar files to jmeter lib ext dir"
        cp -rf "$lib_dir"/* $JMETER_DIR/lib/ext
    fi
fi

if [ "$ROLE" == "worker" ]; then
    $JMETER_DIR/bin/jmeter-server -Jserver.rmi.ssl.disable=true -Jserver.rmi.localport=1099 -Dserver_port=1099  
else
    $JMETER_DIR/agent "$AGENT_PORT"
fi