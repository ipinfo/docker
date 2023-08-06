FROM alpine:latest

RUN apk add --no-cache curl

WORKDIR /data

# set environment variable.
ENV UPDATE_FREQUENCY=0
ENV IPINFO_TOKEN='98266fdad56289'
ENV IPINFO_DATABASES='country_asn'

# copy the script.
COPY ipinfo.sh /usr/local/bin/ipinfo.sh
RUN chmod +x /usr/local/bin/ipinfo.sh

# create the volume.
VOLUME /data

# run the script.
CMD ["/usr/local/bin/ipinfo.sh"]
