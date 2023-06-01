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
