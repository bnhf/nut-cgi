# nut-cgi - Network UPS Tools CGI (NUT-CGI) with expanded output oriented towards use with Portainer

<img width="1348" height="303" alt="screencapture-raspberrypi5-2025-08-30-06_38_15-edit" src="https://github.com/user-attachments/assets/2fce326a-072f-40a6-b0fd-15b323d3f919" />

This Docker implementation of Network UPS Tools CGI is oriented towards use with Portainer via a Docker Compose YAML. Installation can typically be done using only env vars.

The YAML below is intended to be self-documenting, and typically requires no editing. The `Environment variables` section of Portainer should be used for all of your installation-specific values:

```yaml
services:
  nut-cgi: # This docker-compose typically requires no editing. Use the Environment variables section of Portainer to set your values.
    # 2025.08.21
    # GitHub home for this project: https://github.com/bnhf/nut-cgi.
    # Docker container home for this project with setup instructions: https://hub.docker.com/r/bnhf/nut-cgi.
    image: bnhf/nut-cgi:${TAG:-latest} # Add the tag like latest or test to the environment variables below.
    container_name: nut-cgi
    dns_search: ${DOMAIN} # For Tailscale users using Magic DNS, add your Tailnet (tailxxxxx.ts.net) to use hostnames for remote nodes, otherwise use your local domain name.
    ports:
      - ${HOST_PORT:-3494}:80 # The port number to use on your Docker host. 3494 recommended.
    environment:
      - UPSHOSTS=${UPSHOSTS} # Ordered list of hostnames or IP addresses of UPS connected computers (space seperated, no quotes).
      - UPSNAMES=${UPSNAMES} # Matching ordered list of location names to display on status page (space seperated, no quotes).
      - TZ=${TZ} # Timezone to use for status page -- UTC is the default.
      - UPDATE_CONFIGS=${UPDATE_CONFIGS:-true} # Set this to true to update all included config files.
      - UPDATE_HTMLS=${UPDATE_HTMLS:-true} # Set this to true to update all included HTML templates.
    volumes:
      - ${HOST_DIR:-/data}/nut-cgi:/etc/nut # Set the parent directory on your Docker host to contain the nut-cgi data directory.
    restart: unless-stopped
```
And here's a set of sample env vars, which can be copy-and-pasted into Portainer in `Advanced mode`. In that mode, it's quick-and-easy to modify those values for your use. Refer to the comments in the compose for clarification on how a given variable is used:

```yaml
TAG=latest
DOMAIN=localdomain
HOST_PORT=3494
UPSHOSTS=RaspberryPi6 RaspberryPi7 RaspberryPi8 RaspberryPi9 RaspberryPi4 RaspberryPi10 RaspberryPi5
UPSNAMES=Loft Master Great Meadow Closet Shelf Homelab
TZ=US/Mountain
UPDATE_CONFIGS=true
UPDATE_HTMLS=true
HOST_DIR=/data
```
