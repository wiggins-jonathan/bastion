# Bastion
A VPS bastion server forwarding traffic to a server on an internal network via
wireguard.

## Services
- [wireguard](https://www.wireguard.com/)
  * A VPN server.
- [caddy](https://caddyserver.com/)
  * A reverse proxy built with DNS challenge through cloudflare.
- [fail2ban](https://www.fail2ban.org)
  * Reads ssh logs & thwarts repeated attempts to connect to the bastion server.

## Install
- Clone this repository.
- Install `docker` & `docker-compose`.
- Assign the following environment variables required by `docker-compose`:
  * EMAIL
    + Used by caddy for DNS challenge, e.g - `email@example.com`
  * DNS_TOKEN
    + Used by caddy for DNS challenge. This is a secret & care should be used to
      protect it.
  * DOMAIN
    + Used by caddy to reverse proxy, e.g. - example.com

This can be most easily done with with a .env file in the same directory as
`docker-compose.yml`.

Use `docker-compose up -d` to bring up all the containers in the background.
