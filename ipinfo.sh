#!/bin/sh

get_root_url() {
    # Extract the base name without the file extension
    BASE_NAME="${1%%.*}"

    case "$BASE_NAME" in
        "country_asn" | "country" | "asn")
            echo "https://ipinfo.io/data/free/"
            ;;
        *)
            echo "https://ipinfo.io/data/"
            ;;
    esac
}

get_file_extension() {
    case "$1" in
        "mmdb")
            echo ".mmdb"
            ;;
        "csv")
            echo ".csv.gz"
            ;;
        "json")
            echo ".json.gz"
            ;;
        "parquet")
            echo ".parquet"
            ;;
    esac
}

while true; do
    # Check if DEFAULT_DB_FORMAT is set and valid
    if ! [[ "$DEFAULT_DB_FORMAT" =~ ^(mmdb|csv|json|parquet)$ ]]; then
        echo "Error: DEFAULT_DB_FORMAT is either not set, or is not allowed. Please set it to either 'mmdb', 'csv', 'json', or 'parquet'. Value received: '$DEFAULT_DB_FORMAT'"
        break
    fi

    # Iterate over the databases
    for DATABASE in ${IPINFO_DATABASES}; do
        # Check if DATABASE already has a file extension
        if [[ "$DATABASE" != *.* ]]; then
            # Append the correct file extension based on DEFAULT_DB_FORMAT
            FILE_EXTENSION=$(get_file_extension "$DEFAULT_DB_FORMAT")
            DATABASE="${DATABASE}${FILE_EXTENSION}"
        fi

        # Retrieve the correct root URL based on the database name
        BASE_URL=$(get_root_url "$DATABASE")
        DB_URL="${BASE_URL}${DATABASE}"

        if [ -f "${DATABASE}" ]; then
            LOCAL=$(sha256sum "${DATABASE}" | awk '{print $1}')
            REMOTE=$(curl --silent ${DB_URL}/checksums?token=${IPINFO_TOKEN} \
                | sed -n 's/.*"sha256": *"\([a-f0-9]*\)".*/\1/p')
            # Check if the local and remote checksums are the same
            # If they are, skip the download
            if [ "$LOCAL" = "$REMOTE" ]; then
                echo "${DATABASE} is up to date."
                continue
            fi
        fi

        # Download the database
        RESPONSE=$(curl \
            -s -w '%{http_code}' -L -o "${DATABASE}.new" \
            "${DB_URL}?token=${IPINFO_TOKEN}")
        if [ "$RESPONSE" != "200" ]; then
            # Check if response code is 429
            if [ "$RESPONSE" = "429" ]; then
                echo "Rate limit exceeded. Please try again later."
                break
            else 
                echo "$RESPONSE Failed to download ${DATABASE} database from '${DB_URL}'."
                break
            fi
            rm "${DATABASE}.new" 2> /dev/null
        else
            echo "${DATABASE} database downloaded in /data volume."
            mv "${DATABASE}.new" "${DATABASE}"

            # Check if automated extraction of GZ files is enabled
            if [ "$AUTO_EXTRACT_GZ" = "1" ] || [ "$AUTO_EXTRACT_GZ" = "true" ]; then
                # Check if the file is a GZ file
                if [[ "${DATABASE}" == *.gz ]]; then
                    # Extract the GZIP file (while keeping the original)
                    gunzip -k "${DATABASE}"

                    # Check if the extraction was successful
                    if [ $? -eq 0 ]; then
                        echo "Extracted ${DATABASE} to ${DATABASE%.gz}"
                    else
                        echo "Failed to extract ${DATABASE}"
                    fi
                fi
            fi
        fi
    done
    
    if [ "$UPDATE_FREQUENCY" = "0" ]; then
        break
    else
        echo "Sleeping for $UPDATE_FREQUENCY seconds before the next update."
    fi

    sleep "$UPDATE_FREQUENCY"
done
