# [<img src="https://ipinfo.io/static/ipinfo-small.svg" alt="IPinfo" width="24"/>](https://ipinfo.io/) IPinfo-db

`ipinfo-db` is a docker image by [IPinfo.io](https://ipinfo.io) that downloads free country asn database in mmdb format.

## Configuration
`IPINFO_TOKEN` (optional) - Set you ipinfo token.

`UPDATE_FREQUENCY` (optional) - Interval of updating database in bash sleep format 5, 5m, 1d. Default set to 0. 
## Usage:
```bash
docker run -v <dir>:/data  \
  -e IPINFO_TOKEN=<ipinfo_token> \
  -e UPDATE_FREQUENCY=<update_frequency> \
  ipinfo-db
```

## Other IPinfo Tools

There are official IPinfo client libraries available for many languages including PHP, Python, Go, Java, Ruby, and many popular frameworks such as Django, Rails and Laravel. There are also many third party libraries and integrations available for our API.

See [https://ipinfo.io/developers/libraries](https://ipinfo.io/developers/libraries) for more details.

## About IPinfo

Founded in 2013, IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier, VPN detection, hosted domains, and IP type data sets. Our API handles over 40 billion requests a month for businesses and developers.

[![image](https://avatars3.githubusercontent.com/u/15721521?s=128&u=7bb7dde5c4991335fb234e68a30971944abc6bf3&v=4)](https://ipinfo.io/)
