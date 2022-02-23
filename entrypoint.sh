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

INPUT_LOCAL_PATH="/github/workspace/BlazorWeb/Api/" #Hangs, does exist, has content.
INPUT_LOCAL_PATH="/home/runner/work/AzureWebsiteCore/AzureWebsiteCore/BlazorWeb/Api/" #throws as local doesn't exist.
INPUT_LOCAL_PATH="/github/workspace/BlazorWeb/xApi/" #Should throw, won't exist

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

ping 8.8.8.8 -c 2
ping home416919653.1and1-data.host -c 2

ls ${INPUT_LOCAL_PATH}

cat > /tmp/lftp.commands <<EOF
set ssl:priority true
set ssl:verify-certificate true
set ftp:ssl-force true
user u69050957-BlazorWeb ${INPUT_PASSWORD}
ls
EOF

lftp sftp://home416919653.1and1-data.host:22 < /tmp/lftp.commands

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
