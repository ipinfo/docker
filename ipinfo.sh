#!/bin/sh

while true; do
    for DATABASE in ${IPINFO_DATABASES}; do
        if [ -f ${DATABASE}.mmdb ]; then
            LOCAL=$(sha256sum ${DATABASE}.mmdb | awk '{print $1}')
            REMOTE=$(curl --silent https://ipinfo.io/data/free/${DATABASE}.mmdb/checksums?token=${IPINFO_TOKEN} \
                | sed -n 's/.*"sha256": *"\([a-f0-9]*\)".*/\1/p')
            if [ "$LOCAL" = "$REMOTE" ]; then
                echo "${DATABASE}.mmdb is up-to-date."
                continue
            fi
        fi
        RESPONSE=$(curl \
            -s -w '%{http_code}' -L -o "${DATABASE}.mmdb.new" \
            "https://ipinfo.io/data/free/${DATABASE}.mmdb?token=${IPINFO_TOKEN}")
        if [ "$RESPONSE" != "200" ]; then
            echo "$RESPONSE Failed to download ${DATABASE}.mmdb database."
            rm "${DATABASE}.mmdb.new" 2> /dev/null
        else
            echo "${DATABASE}.mmdb database downloaded in /data volume."
            mv "${DATABASE}.mmdb.new" "${DATABASE}.mmdb"
        fi
    done
    
    if [ $UPDATE_FREQUENCY == 0 ]; then
        break
    fi

    sleep "$UPDATE_FREQUENCY"
done
