# Dynamic DNS using DigitalOcean's DNS Services

[![](https://images.microbadger.com/badges/image/tunix/digitalocean-dyndns.svg)](https://microbadger.com/images/tunix/digitalocean-dyndns "Get your own image badge on microbadger.com")

A script that pushes the public IP address of the running machine to DigitalOcean's DNS API's. It requires an existing A record to update. The resulting container image is roughly around 7 MB (thanks to Alpine Linux).

## Setup

Assuming you already have a DigitalOcean account and your domain associated with it. Just add an A record with desired name and IP address. That's it!

## Usage

Pick one of the options below using the following settings:

* **DIGITALOCEAN_TOKEN:** The token you generate in DigitalOcean's API settings.
* **DOMAIN:** The domain your subdomain is registered at. (i.e. `foo.com` for `home.foo.com`)
* **NAME:** Subdomain to use. (name in A record) (i.e. `home` for `home.foo.com`). Multiple subdomains must be separated by semicolons `;`
* **SLEEP_INTERVAL:** Polling time in seconds. (default: 300)

### Docker (Recommended)

```
$ docker pull tunix/digitalocean-dyndns
$ docker run -d --name dyndns \
    -e DIGITALOCEAN_TOKEN="your_token_here" \
    -e DOMAIN="yourdomain.com" \
    -e NAME="subdomain" \
    -e SLEEP_INTERVAL=2 \
    tunix/digitalocean-dyndns
```

### Manual

You can also create a cronjob using below command:

```
$ DIGITALOCEAN_TOKEN="your_token_here" DOMAIN="yourdomain.com" NAME="subdomain" SLEEP_INTERVAL=2 ./dyndns.sh
```
