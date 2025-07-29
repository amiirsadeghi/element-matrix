# Element Matrix Self-Hosted Stack

This project provides a fully containerized setup for deploying your own secure and private **Element + Matrix Synapse** server with **PostgreSQL** and **Nginx** using **Docker Compose**.

---

## 📁 Project Structure

```text
.
├── element-web/
│   └── config.json                 # Element Web configuration file
├── nginx/
│   ├── ssl/
│   │   ├── fullchain.pem           # SSL certificate
│   │   └── private.key             # SSL private key
│   └── nginx.conf                  # Nginx configuration file
├── postgres/
│   ├── init-entrypoint.sh          # Script to generate init.sql from template
│   └── init.sql                    # Final init SQL executed by container
├── synapse/
│   ├── scripts/
│   │   └── entrypoint.sh           # Generates homeserver.yaml and starts Synapse
│   ├── Dockerfile                  # Builds Synapse image with gettext
│   └── homeserver.yaml.template   # Synapse configuration template
├── .env                            # Environment variables
├── .gitignore                      # Git ignored files
├── README.md                       # This documentation file
├── docker-compose.yml              # Main Docker Compose file to start all services
```

---

## 🧠 What is Element?

[Element](https://element.io/) is a modern messaging app built on top of the [Matrix](https://matrix.org/) open standard. It allows you to:

* Self-host your own chat infrastructure
* Enable secure and decentralized communication
* Integrate with identity providers, bots, and other services

This setup helps you fully own your data and deploy a production-grade Element server.

---

## ⚙️ Setup Step-by-Step

### ✅ 1. Clone the Repository

```bash
git clone https://github.com/amiirsadeghi/element-matrix.git
cd element-matrix
```

### ✅ 2. Prepare `.env`

Create a `.env` file in the root directory:

```env
POSTGRES_DB=synapse
POSTGRES_USER=synapse
POSTGRES_PASSWORD=StrongPassword123
SYNAPSE_SERVER_NAME=your-domain.com
SYNAPSE_REPORT_STATS=yes
```

These values are used to fill in `homeserver.yaml` and PostgreSQL init.

### ✅ 3. Set Up SSL Certificates

Place your SSL certs in:

```
nginx/ssl/fullchain.pem
nginx/ssl/private.key
```

You can use Let's Encrypt or your custom CA.

### ✅ 4. Build the Synapse Image

Before running the stack, you need to build the custom Synapse image which includes the `gettext` package for dynamic config generation:

```bash
docker build -t synapse-custom ./synapse
```

Make sure your `docker-compose.yml` refers to this image:

```yaml
  synapse:
    image: synapse-custom
    ...
```

### ✅ 5. PostgreSQL Configuration

We don't hardcode credentials in SQL files. Instead, we use `init.sql.template` (not committed to Git, it gets rendered at runtime).

The `init-entrypoint.sh` script uses `envsubst` to replace placeholders in the template and generate `init.sql`, which is then executed by the default PostgreSQL Docker image:

```bash
envsubst < /docker-entrypoint-initdb.d/init.sql.template > /docker-entrypoint-initdb.d/init.sql
exec docker-entrypoint.sh "$@"
```

This keeps credentials safe and configs dynamic.

### ✅ 6. Synapse Configuration

Similarly, `homeserver.yaml.template` is used instead of a static file. This approach ensures your Synapse config stays flexible and reusable.

The `entrypoint.sh` in `synapse/scripts/` does:

```bash
envsubst < /data/homeserver.yaml.template > /data/homeserver.yaml
exec python3 -m synapse.app.homeserver --config-path /data/homeserver.yaml
```

This is part of the image you build in Step 4.

### ✅ 7. Element Configuration

Located at `element-web/config.json`, with example:

```json
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "https://your-domain.com",
      "server_name": "your-domain.com"
    }
  },
  "disable_custom_urls": true,
  "disable_guests": true,
  "brand": "Your Matrix Chat",
  "default_theme": "light",
  "roomDirectory": {
    "servers": ["your-domain.com"]
  }
}
```

This file is mounted into the Element container and served statically by Nginx.

### ✅ 8. Nginx Reverse Proxy

Handles SSL termination and reverse proxying for both Synapse and Element.

Ensure ports **80** and **443** are exposed, and your domain points to the host machine.

---

## 🚀 Run the Stack

Once your `.env` is ready, SSL certs are placed, and Synapse image is built:

```bash
docker compose up -d
```

This will:

* Use the prebuilt Synapse image
* Init PostgreSQL with dynamic script
* Generate Synapse config
* Serve Element UI
* Enable Nginx with SSL termination

Wait \~20 seconds, then open:

```
https://your-domain.com
```

---

## 📌 Notes

* Do **not** commit real `fullchain.pem` or `private.key` files to GitHub.
* You can add LDAP, Jitsi, or email config in later stages.
* Keep `.env` out of version control unless values are safe.

---

## 📫 Future Improvements

* LDAP integration
* Secure registration
* Jitsi video calls
* GitHub Actions for CI/CD deployment

---

## 🧑‍💻 Author

Amir Sadeghi — [GitHub](https://github.com/amiirsadeghi)

---

Feel free to fork or contribute!
