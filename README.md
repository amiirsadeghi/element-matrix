# Element + Synapse (Matrix) On-Premise Setup

A self-hosted Matrix stack with a custom-built Synapse image and Element web client using Docker Compose. This project is designed for production-ready deployments with PostgreSQL and customizable configuration.

---

## 🧩 Project Structure

This repository provides a fully dockerized setup for deploying a Matrix homeserver (`Synapse`) along with the official Element client. Key features include:

- Custom Docker image for Synapse
- Dynamic generation of `homeserver.yaml` via environment variables
- Secure reverse proxy with NGINX and SSL support
- Production-ready PostgreSQL integration
- Optional customization for domain, federation, registration, etc.

---

## 📁 Directory Overview

```bash
element-matrix/
├── element/               # Element web client container setup
├── nginx/                 # NGINX reverse proxy with SSL certs
│   └── ssl/               # Place your `fullchain.pem` and `private.key` here
├── synapse/               # Synapse homeserver setup
│   ├── homeserver.yaml.template  # Templated config file
│   ├── Dockerfile         # Custom Dockerfile for Synapse
│   └── entrypoint.sh      # Entrypoint script that builds the config dynamically
├── .env                   # Environment variables (see below)
├── docker-compose.yml     # Docker Compose setup
└── README.md              # This file
🚀 Getting Started
1. Clone the repository

git clone https://github.com/amiirsadeghi/element-matrix.git
cd element-matrix
. Set up environment variables

Create a .env file in the root directory with values matching your setup:

POSTGRES_DB=synapse
POSTGRES_USER=synapse
POSTGRES_PASSWORD=your_secure_password
SYNAPSE_SERVER_NAME=your.domain.com
REPORT_STATS=yes

You can customize more options depending on your homeserver.yaml.template.
3. Place SSL Certificates

Put your SSL certificates into nginx/ssl/ directory:

    nginx/ssl/fullchain.pem

    nginx/ssl/private.key

🐳 Custom Synapse Docker Image

A custom Docker image is built using a templated homeserver.yaml. The config is generated on container start using envsubst.
🔧 entrypoint.sh

#!/bin/bash
set -e

envsubst < /data/homeserver.yaml.template > /data/homeserver.yaml

exec python3 -m synapse.app.homeserver \
  --config-path /data/homeserver.yaml

This allows configuration to be adjusted dynamically through environment variables.
🧱 Build the Image

cd synapse/
docker build -t synapse-custom:1.0.0 .

🐘 Database: PostgreSQL

This setup uses PostgreSQL instead of SQLite, making it more suitable for production use.

    The database container is named postgres

    Database name, user, and password are controlled via .env

    Synapse connects using these environment values via the template config

📦 Docker Compose Usage

Once everything is set up:

docker-compose up -d

This brings up:

    Synapse (using synapse-custom:1.0.0)

    Element Web

    NGINX reverse proxy

    PostgreSQL

📄 Configuration Template

You can edit synapse/homeserver.yaml.template to customize federation, registration, email settings, TURN server, etc. Any ${VAR} will be replaced using environment variables during container startup.
🌐 Access

    Element Web: https://your.domain.com

    Matrix Homeserver: https://your.domain.com (via federation or client config)

🛠 Future Improvements

    Add support for Jitsi integration

    LDAP authentication (optional)

    Registration token control

📖 References

    Matrix Synapse

    Element Web

    PostgreSQL

    Docker

🔒 Security Notice

Make sure to:

    Use strong PostgreSQL credentials

    Keep your SSL certs updated

    Restrict registration in production (unless you trust open signups)
