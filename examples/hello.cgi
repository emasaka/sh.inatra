#!/bin/bash

. /opt/sh.inatra/sh.inatra.sh

get '/hello' && {
    echo 'Hello, World'
}

get '/say/*/to/*' && {
    echo Say ${params_splat[0]} to ${params_splat[1]}
}
