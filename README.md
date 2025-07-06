# Self‑Hosted Matrix Synapse + Element Stack 🚀

This repository hosts a fully containerized Matrix chat stack using **Synapse** (backend) with a **PostgreSQL** database and **Element** (frontend). It’s production-ready, secure, and optimized for performance.

---

## 📁 Project Structure

```
.
├── docker-compose.yml
├── homeserver.template.yaml
├── .env.example
├── scripts/               # optional helper scripts (e.g., setup, maintenance)
└── README.md
```

---

## 🔒 Security & Configuration

- All sensitive data (e.g. secrets, domains, DB credentials) are in **`.env`**.
- `.env` is **not committed**—tracked via `.gitignore`.
- `homeserver.yaml` is generated at runtime inside the Synapse container using:
  ```bash
  docker run -it --rm \
    -v "$(pwd)/data/synapse:/data" \
    -e SYNAPSE_SERVER_NAME=your.domain.com \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest generate
  ```
- The template is processed with:
  ```bash
  envsubst < /data/homeserver.yaml.template > /data/homeserver.yaml
  ```
- Finally, Synapse is started using:
  ```bash
  exec python3 -m synapse.app.homeserver \
    --config-path /data/homeserver.yaml
  ```

---

## 🧩 Why PostgreSQL?

- Replaces SQLite for faster and more stable production usage.
- You’ve **compiled the PostgreSQL schema**, ensuring compatibility so Synapse can read and write correctly.

---

## 🏗 Deployment Steps

1. **Clone the repo**
   ```bash
   git clone https://github.com/yourname/element-matrix.git
   cd element-matrix
   ```

2. **Set up environment**
   ```bash
   cp .env.example .env
   # Edit .env to set domain, DB credentials, etc.
   ```

3. **Launch the stack**
   ```bash
   docker-compose up -d
   ```

4. **Generate `homeserver.yaml` (first run)**
   ```bash
   docker-compose exec synapse \
     /bin/sh -c 'matrixdotorg/synapse:latest generate && \
     envsubst < /data/homeserver.yaml.template > /data/homeserver.yaml'
   ```

5. **Register the admin user**
   ```bash
   docker-compose exec synapse \
     register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008
   ```

6. **Access Element**
   - Visit `https://your.domain.com` and log in using your Matrix ID.

---

## 🔧 Files to Commit & Ignore

✅ **Include in Git:**
- `docker-compose.yml`
- `homeserver.template.yaml`
- `scripts/` (if any)
- `.env.example`

❌ **Ignore via `.gitignore`:**
```
.env
data/synapse/
data/postgres/
*.log
```

---

## 💬 Why Matrix + Element for Enterprise Chat?

- **Open-source & self‑hosted** – full data control, no vendor lock-in.
- **End-to-End Encryption** (E2EE) out-of-the-box.
- **Federated architecture** – decentralization as a feature.
- **Enterprise-friendly** – supports LDAP, SSO, bridges to Slack, Telegram, etc.
- **Rich UX** – channels, threads, threads, voice/video calls (via Jitsi or LiveKit).
- **Scalable** – Synapse with PostgreSQL handles load efficiently.

---

## 🛠 Step‑by‑Step Implementation Overview

1. **Design stack** – Docker Compose with Synapse, Postgres, and Element.
2. **Implement `.env`** – centralize all sensitive configuration.
3. **Template homeserver YAML** – use `*.template.yaml` with `envsubst`.
4. **Generate on-the-fly** – startup script builds `homeserver.yaml` in container.
5. **Integrate PostgreSQL** – compiled schema, set `database:` block in template.
6. **Launch & bootstrap** – bring up services, then create admin.
7. **Serve Element** – connect Synapse backend via `docker-compose.yml`.
8. **(Optional) Add HTTPS** – reverse proxy like nginx + TLS certs.
9. **Use production features** – bridges, LDAP, SSO, monitoring, scaling.

---

## ✅ Quick Start

```bash
git clone ...
cd element-matrix

cp .env.example .env
# customize your variables here

docker-compose up -d

# generate config and template
docker-compose exec synapse sh -c '
  matrixdotorg/synapse:latest generate && \
  envsubst < /data/homeserver.yaml.template > /data/homeserver.yaml
'

# register admin
docker-compose exec synapse register_new_matrix_user \
  -c /data/homeserver.yaml http://localhost:8008
```

---

## 🛡 License

MIT License – feel free to adapt.

---

This setup gives you a secure, high‑performance, self‑hosted chat system using Matrix + Element, ideal for internal corporate communication.
