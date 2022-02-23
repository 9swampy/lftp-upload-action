#!/bin/sh -l

INPUT_SSL_VERIFY_CERT=${INPUT_SSL_VERIFY_CERT:-true}
INPUT_SSL_FORCE=${INPUT_SSL_FORCE:-false}

# "NORMAL:%COMPAT:+VERS-TLS1.0"
#SSL_PRIORITY=${SSL_PRIORITY}

URI="${INPUT_PROTOCOL:=ftp}"'://'"${INPUT_HOST}"

#if [ ! -n "${INPUT_PORT}" ]; then
    echo "Forced Suffix port..."
    URI="${URI}:${INPUT_PORT}"
#fi

#USERNAME
#PASSWORD
#ARGS
#REMOTE_PATH
#LOCAL_PATH

INPUT_LOCAL_PATH="/github/workspace/BlazorWeb/Api/"

echo "Debug params"
echo "Uri=${URI}"
echo "INPUT_PORT=${INPUT_PORT}"
echo "UserName=${INPUT_USERNAME}"
echo "Local=${INPUT_LOCAL_PATH}"
echo "Remote=${INPUT_REMOTE_PATH}"
echo "INPUT_SSL_VERIFY_CERT=${INPUT_SSL_VERIFY_CERT}"
echo "INPUT_SSL_FORCE=${INPUT_SSL_FORCE}"

ARGS="${INPUT_MIRROR_ARGS}"
echo "ARGS=${ARGS}"

ls ${INPUT_LOCAL_PATH}

#--reverse sends file to the server from the LOCAL_PATH
#set ssl:priority ${INPUT_SSL_PRIORITY}
lftp $URI << TRANSFER    
    set ssl:verify-certificate ${INPUT_SSL_VERIFY_CERT}
    set ftp:ssl-force ${INPUT_SSL_FORCE}
    user ${INPUT_USERNAME} ${INPUT_PASSWORD}
    ls ${INPUT_REMOTE_PATH}
    mirror --verbose --reverse $ARGS ${INPUT_LOCAL_PATH} ${INPUT_REMOTE_PATH}
    exit
TRANSFER

echo "Exit $?"
