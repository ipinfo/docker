#!/bin/sh

get_root_url() {
    case "$1" in
        "country_asn" | "country" | "asn")
            echo "https://ipinfo.io/data/free/"
            ;;
        *)
            echo "https://ipinfo.io/data/"
            ;;
    esac
}

while true; do
    for DATABASE in ${IPINFO_DATABASES}; do
        BASE_URL=$(get_root_url "$DATABASE")
        DB_URL="${BASE_URL}${DATABASE}.mmdb"
        if [ -f ${DATABASE}.mmdb ]; then
            LOCAL=$(sha256sum ${DATABASE}.mmdb | awk '{print $1}')
            REMOTE=$(curl --silent ${DB_URL}/checksums?token=${IPINFO_TOKEN} \
                | sed -n 's/.*"sha256": *"\([a-f0-9]*\)".*/\1/p')
            if [ "$LOCAL" = "$REMOTE" ]; then
                echo "${DATABASE}.mmdb is up-to-date."
                continue
            fi
        fi
        RESPONSE=$(curl \
            -s -w '%{http_code}' -L -o "${DATABASE}.mmdb.new" \
            "${DB_URL}?token=${IPINFO_TOKEN}")
        if [ "$RESPONSE" != "200" ]; then
            echo "$RESPONSE Failed to download ${DATABASE}.mmdb database."
            rm "${DATABASE}.mmdb.new" 2> /dev/null
        else
            echo "${DATABASE}.mmdb database downloaded in /data volume."
            mv "${DATABASE}.mmdb.new" "${DATABASE}.mmdb"
        fi
    done
    
    if [ "$UPDATE_FREQUENCY" = "0" ]; then
        break
    fi

    sleep "$UPDATE_FREQUENCY"
done
