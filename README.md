# docker-trickle-megasync
Docker image with Alpine, Megasync and Trickle for rate-limited sync with Mega.nz

Features:
- Headless sync with Mega.nz
- Cross platform
- integrated Trickle (https://github.com/mariusae/trickle) for bandwidth limiting (optional)

Usage:
- Edit the `docker-compose.yml` file
  - Change the drive mapping to your local directory
  - Add your Mega credentials 
  - Change desired bandwidth parameters or remove Trickle completely (default:  1MB/s down and up)
- `docker-compose build`
- `docker-compose up -d`
