# Bastion
A VPS bastion server forwarding traffic to an internal network via headscale.

## Services
- [headscale](https://github.com/juanfont/headscale)
  * A mesh VPN server.
- [caddy](https://caddyserver.com/)
  * A reverse proxy built with DNS challenge through cloudflare.
- [fail2ban](https://www.fail2ban.org)
  * Reads ssh logs & thwarts repeated attempts to connect to the bastion server.

## Install
- Clone this repository.
- Install `docker`, `docker-compose`, `terraform`, & `sops`.
- Use terraform to create free infrastructure on Oracle Cloud:
  * All resources are available in the `terraform` directory.
  * Required variables for this infrastructure are encrypted in
    `secrets.auto.tfvars.json` & are automatically injected at runtime. Decrypt
    this file or create a new file with the appropriate variables from your
    particular use case.
  * Run:
    + `terraform init`
    + `terraform plan`
    + `terrafrom apply`
- Use docker compose to bring up app infrastructure:
  * All resources are available in the `webservices` directory.
  * Required variables for this infrastructure are encrypted in `.env` & are
    automatically injected at runtime. Decrypt this file or create a new file
    with the appropriate variables.
    + `EMAIL` Used by caddy for DNS challenge, e.g. - `email@example.com`.
    + `DOMAIN` Used by caddy to reverse proxy, e.g. - `example.com`.
    + `CLOUDFLARE_API_TOKEN` Used by caddy for DNS challenge.
    + `TZ` A TZ identifier, e.g. - `Africa/Abidjan`
  * Run: `docker compose up -d`
