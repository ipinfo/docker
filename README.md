# [<img src="https://ipinfo.io/static/ipinfo-small.svg" alt="IPinfo" width="24"/>](https://ipinfo.io/) IPinfo Docker Image

`ipinfo-db` is a docker image by [IPinfo.io](https://ipinfo.io) that downloads IPInfo databases (for info on what DBs are available, see [here](https://ipinfo.io/developers/database-filename-reference)).

## Pull image
```bash
docker pull ipinfo/ipinfo-db:latest
```

## Configuration

- `IPINFO_TOKEN` (required) - Set you IPInfo token available in your [dashboard](https://ipinfo.io/dashboard/token).
- `IPINFO_DATABASES` (optional) - Space-separated list of databases to download. **Notes**:  
**(1)** The default value is set to `country_asn.mmdb` to ensure backwards compatibility with the previous version of the image, but we recommend using the newer `ipinfo_lite` database instead. The data provided by `ipinfo_lite` is the same as `country_asn`, but the schema has changed. See [here](https://github.com/ipinfo/docker/issues/9#issuecomment-2868624800) for more details.
- `UPDATE_FREQUENCY` (optional) - Interval of updating database in bash sleep format. If this is not set or is set to `0` (default), image will run once and exit.
- `DEFAULT_DB_FORMAT` (optional) - Default database format. Can be `mmdb`, `csv`, `json` or `parquet`. Defaults to `mmdb`.
- `AUTO_EXTRACT_GZ` (optional) - If set to `true` or `1`, the downloaded files will be extracted from gzipped format. Defaults to `false`. **Notes**:  
**(1)** This increases the storage requirements of downloaded files, as both th `.gz` file, and the extracted file will be stored in the same directory - this is to check the hash of the file on disk against the hash of the file on IPinfo's servers (and prevent re-downloading the same file).  
**(2)** This variable is only relevant for `.csv` and `.json` files, as the `.mmdb` and `.parquet` files are not gzipped on IPinfo's servers.

## Usage:

```bash
docker run -v <dir>:/data  \
  -e IPINFO_TOKEN=<ipinfo_token> \
  -e UPDATE_FREQUENCY=<update_frequency> \
  ipinfo/ipinfo-db
```

`<dir>` local directory that you want to download the databases to.

## Other IPinfo Tools

There are official IPinfo client libraries available for many languages including PHP, Python, Go, Java, Ruby, and many popular frameworks such as Django, Rails and Laravel. There are also many third party libraries and integrations available for our API.

See [https://ipinfo.io/developers/libraries](https://ipinfo.io/developers/libraries) for more details.

## About IPinfo

Founded in 2013, IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier, VPN detection, hosted domains, and IP type data sets. Our API handles over 40 billion requests a month for businesses and developers.

[![image](https://avatars3.githubusercontent.com/u/15721521?s=128&u=7bb7dde5c4991335fb234e68a30971944abc6bf3&v=4)](https://ipinfo.io/)
