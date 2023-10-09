#!/bin/bash

src_dir="/jmeter_src"

if [ -n "$SOURCE_DIR" ]; then
    echo "jmeter project will be used from $SOURCE_DIR"
    src_dir=$SOURCE_DIR
elif [ -n "$SOURCE_GIT_URL" ]; then
    echo "jmeter project will be cloned from $SOURCE_GIT_URL"
    echo "Git clone $SOURCE_GIT_URL to folder $src_dir"
    git clone "$SOURCE_GIT_URL" $src_dir
    if [ -z "$?" ]; then
        echo "Failed to git clone from $SOURCE_GIT_URL"
        exit 1
    fi
else
    echo "environment variables SOURCE_DIR or SOURCE_GIT_URL is required"
    exit 1
fi

relative_project_dir=jmeter
if [ -n "$PROJECT_DIR" ]; then
    relative_project_dir=$PROJECT_DIR
fi
project_dir=$src_dir/$relative_project_dir

relative_lib_ext_dir=lib
if [ -n "$LIB_EXT_DIR" ]; then
    relative_lib_ext_dir=$LIB_EXT_DIR
fi
lib_dir=$src_dir/$relative_lib_ext_dir

if [ ! "$(ls -A "$project_dir")" ]; then
        echo "The jmeter dir should not be empty"
        exit 1
fi
cp -rf "$project_dir" project

if [ -d "$lib_dir" ]; then
    if [ "$(ls -A "$lib_dir")" ]; then
        echo "copy customized lib ext jar files to jmeter lib ext dir"
        cp -rf "$lib_dir"/* lib/ext
    fi
fi

if [ "$ROLE" == "worker" ]; then
    bin/jmeter-server -Jserver.rmi.ssl.disable=true -Jserver.rmi.localport=1099 -Dserver_port=1099  
else
    ./agent "$AGENT_PORT"
fi