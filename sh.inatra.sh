# sh.inatra.sh:
#   CGI shell script framework looks like sinatra.

## private global variables

declare shinatra_tmpfile=/tmp/shinatra_tmp.$RANDOM$$
declare REQUEST_URI_PARAM=${REQUEST_URI#$SCRIPT_NAME}
declare REQUEST_URI_PATH=${REQUEST_URI_PARAM%%\?*}
declare routing_matched

declare RESPONSE_CONTENT_TYPE='text/html'
declare RESPONSE_CHARSET='utf-8'
declare RESPONSE_STATUS='200 OK'

## public global variables

declare -a params_splat

## public functions

function get() {
    shinatra::route GET "$1"
}

function post() {
    shinatra::route POST "$1"
}

function content_type() {
    RESPONSE_CONTENT_TYPE=$1
    [ "$2" = :charset ] && RESPONSE_CHARSET=$3
}

function status() {
    RESPONSE_STATUS=$*
}

function redirect() {
    local uri=$1
    RESPONSE_STATUS='302 Found'
    RESPONSE_LOCATION="http://$SERVER_NAME$SCRIPT_NAME$uri"
}

## private functions

function shinatra::route() {
    [ -n "$routing_matched" ] && return -1

    local verb=$1
    local path=$2
    local re=$(shinatra::compile_path "$path")
    local -i i

    params_splat=()
    if [ "$REQUEST_METHOD" = "$verb" ] && [[ "$REQUEST_URI_PATH" =~ $re ]]; then
	for ((i = 1; i < ${#BASH_REMATCH[@]}; i++)) {
	    params_splat[i - 1]=$(URI.unescape "${BASH_REMATCH[i]}")
	}
	routing_matched=true
	return 0
    fi
    return -1
}

function shinatra::compile_path() {
    local path=$1

    # escape special chars
    path=${path//./\\.}
    path=${path//+/\\+}
    path=${path//\(/\\(}
    path=${path//)/\\)}

    # wildcard
    path=${path//\*/(.*?)}

    echo "^$path\$"
}

function shinatra::extract_params() {
    local query=${REQUEST_URI_PARAM#*\?}
    if [ "$REQUEST_METHOD" = POST ] && [[ -n "$CONTENT_LENGTH" ]]; then
	local str
	IFS='' read -r -n "$CONTENT_LENGTH" str
	if [ -n "$query" ]; then
	    query="$query&$str"
	else
	    query=$str
	fi
    fi

    local p var val IFS
    IFS='&'
    for p in $query; do
	if [[ "$p" == *=* ]]; then
	    var=${p%%=*}
	    val=${p#*=}
	    eval "params_${var#:}='$(URI.unescape $val)'"
	fi
    done
}

function URI.unescape() {
    local str=$1
    str=${str//+/ }
    str=${str//%/\\x}
    echo -e "$str"
}

function response.newline() {
    echo -ne '\r\n'
}

function shinatra::send_response() {
    if [ -n "$routing_matched" ]; then
	echo -n "Status: $RESPONSE_STATUS"
	response.newline
	echo -n "Content-Type: $RESPONSE_CONTENT_TYPE; charset=$RESPONSE_CHARSET"
	response.newline
	if [ -n "$RESPONSE_LOCATION" ]; then
	    echo -ne "Location: $RESPONSE_LOCATION"
	    response.newline
	fi
	response.newline
	while read -r line; do
	    echo "$line"
	done < $shinatra_tmpfile
    else
	echo -ne 'Status: 404 Not Found'
	response.newline
	echo -ne 'Content-Type: text/plain'
	response.newline
	response.newline
	echo '404 Not Found'
    fi >&5			# 5 is a copy of stdout
}

## main

shinatra::extract_params
trap 'shinatra::send_response; rm -f $shinatra_tmpfile' EXIT
: > $shinatra_tmpfile
exec 5>&1
exec > $shinatra_tmpfile
