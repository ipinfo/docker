#!/bin/sh

while true; do

    # download the database.
    RESPONSE=$(curl -s -w '%{http_code}' -L -o "country_asn.mmdb" "https://ipinfo.io/data/free/country_asn.mmdb?token=c0c038dbe0e4e7")
    if [ "$RESPONSE" != "200" ]; then
        echo "$RESPONSE Failed to download database."
        rm country_asn.mmdb
    fi
    
    if [ $UPDATE_FREQUENCY == 0 ]; then
        break
    fi

    sleep "$UPDATE_FREQUENCY"
done
