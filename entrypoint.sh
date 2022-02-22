#!/bin/sh -l

INPUT_SSL_VERIFY_CERT=${INPUT_SSL_VERIFY_CERT:-true}
INPUT_SSL_FORCE=${INPUT_SSL_FORCE:-false}

# "NORMAL:%COMPAT:+VERS-TLS1.0"
#SSL_PRIORITY=${SSL_PRIORITY}

URI="${INPUT_PROTOCOL:=ftp}"'://'"${INPUT_HOST}"

if [ ! -n $INPUT_PORT ]; then
    URI=$URI:$INPUT_PORT
fi

#USERNAME
#PASSWORD
#ARGS
#REMOTE_PATH
#LOCAL_PATH

URI="sftp://home416919653.1and1-data.host:22"
INPUT_USERNAME="u69050957-BlazorWeb"
INPUT_LOCAL_PATH="/home/runner/work/AzureWebsiteCore/AzureWebsiteCore/BlazorWeb/Api/"
INPUT_REMOTE_PATH="/"
INPUT_SSL_VERIFY_CERT=$false
INPUT_SSL_FORCE=$true

ARGS="${INPUT_MIRROR_ARGS}"
echo "Uri=${URI}"
echo "UserName=${INPUT_USERNAME}"
echo "Local=${INPUT_LOCAL_PATH}"
echo "Remote=${INPUT_REMOTE_PATH}"
echo "INPUT_SSL_VERIFY_CERT=${INPUT_SSL_VERIFY_CERT}"
echo "INPUT_SSL_FORCE=${INPUT_SSL_FORCE}"
echo "ARGS=${ARGS}"

#--reverse sends file to the server from the LOCAL_PATH
#set ssl:priority ${INPUT_SSL_PRIORITY}
lftp $URI << TRANSFER    
    set ssl:verify-certificate ${INPUT_SSL_VERIFY_CERT}
    set ftp:ssl-force ${INPUT_SSL_FORCE}
    user $INPUT_USERNAME $INPUT_PASSWORD

    mirror --verbose --reverse $ARGS $INPUT_LOCAL_PATH $INPUT_REMOTE_PATH
TRANSFER

echo "Exit $?"
