#!/bin/sh

while true; do
    # download the database.
    RESPONSE=$(curl -s -w '%{http_code}' -L -o "country_asn.mmdb" "https://ipinfo.io/data/free/country_asn.mmdb?token=${IPINFO_TOKEN}")
    if [ "$RESPONSE" != "200" ]; then
        echo "$RESPONSE Failed to download database."
        rm country_asn.mmdb
    else
        echo "country_asn.mmdb database downloaded in /data volume"
    fi
    
    if [ $UPDATE_FREQUENCY == 0 ]; then
        break
    fi

    sleep "$UPDATE_FREQUENCY"
done
