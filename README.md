# Inception – 42 Project

## 📌 Project Overview
The **Inception** project at 42 is about learning containerization by setting up a small infrastructure entirely with **Docker** and **docker-compose**.  
The goal is to build and configure multiple services inside isolated containers, making them communicate through Docker networks while persisting their data using volumes.

This project helps you understand:
- How containers work under the hood (namespaces, cgroups, layers).
- How services like **Nginx**, **MariaDB**, and **WordPress with PHP-FPM** interact.
- How to manage volumes, networks, and entrypoints in a production-like setup.

---

## 🏗️ Project Architecture

Your stack contains **3 main containers**:

1. **Nginx**
   - Acts as a reverse proxy.  
   - Listens on port **443 (HTTPS)** with self-signed SSL.  
   - Forwards PHP requests to WordPress (php-fpm).  

2. **WordPress + PHP-FPM**
   - WordPress website running with PHP 8.2.  
   - PHP-FPM listens on port 9000 (FastCGI) instead of a Unix socket.  
   - Configured automatically with WP-CLI at container startup.  

3. **MariaDB**
   - Relational database storing WordPress data.  
   - Database, user, and password configured at first run.  
   - Data persisted in a volume (`/home/user/data/mariadb`).  

---

## ⚙️ How to Run
Clone the repository and run:
```bash
make all
```

- Containers are built from custom **Dockerfiles** (no pre-built images like `nginx:latest`).  
- Data is stored persistently in **bind-mounted volumes**:
  - `~/Desktop/data/mariadb`  
  - `~/Desktop/data/wordpress`  

Stop and clean everything:
```bash
make fclean
```

---

## 📂 Project Structure
```
.
├── srcs/
│   ├── docker-compose.yml   # Orchestrates all services
│   ├── requirements/
│   │   ├── nginx/
│   │   │   ├── Dockerfile
│   │   │   └── conf/nginx.conf
│   │   ├── mariadb/
│   │   │   ├── Dockerfile
│   │   │   └── tools/init.sh
│   │   └── wordpress/
│   │       ├── Dockerfile
│   │       └── tools/auto_config.sh
└── Makefile
```

---

## 🧠 Key Concepts (for evaluation)

### 🐳 Containers
- Built on Linux **namespaces** (process, network, mount, pid, etc.) → isolate resources.  
- Controlled by **cgroups** → limit CPU, RAM, I/O usage.  
- Made of **layers** (each Dockerfile instruction = new layer).  

### 📡 Networking
- All services share a custom **bridge network**.  
- They can resolve each other by container name (`nginx`, `wordpress`, `mariadb`).  

### 💾 Volumes
- Used for **data persistence**.  
- Here we use **bind mounts**:
  ```yaml
  driver_opts:
    device: /home/sel-jadi/Desktop/data/mariadb
    type: none
    o: bind
  ```
  → Maps a host folder directly into the container.  

### ⚡ PHP-FPM, CGI, and FastCGI
- **CGI** = old protocol: 1 process per request (slow).  
- **FastCGI** = improved: pool of PHP workers → reused → faster.  
- **PHP-FPM** = FastCGI manager specialized for PHP.  
- We run PHP-FPM in the foreground (`exec php-fpm -F`) so it becomes PID 1 inside the container.  

### 🚦 Entrypoint vs CMD
- **ENTRYPOINT** = always executed first → main process (PID 1).  
- **CMD** = default arguments, can be overridden.  
- If no ENTRYPOINT, CMD acts as the command.  

### 🔐 SSL
- Generated self-signed certificate inside Nginx.  
- Forces traffic over **HTTPS (port 443)**.  

---

## ❓ Common Evaluation Questions

- **Why not use `nginx:latest` image?**  
  Because the project requires building images **from scratch** with Debian base.  

- **Why PHP-FPM instead of Apache with mod_php?**  
  Separation of concerns → Nginx handles static files + SSL, PHP-FPM only executes PHP (faster, more secure).  

- **Why run PHP-FPM in foreground?**  
  In Docker, the container stops when PID 1 exits. Running it in foreground keeps the container alive.  

- **What’s the difference between a volume and a bind mount?**  
  - Volume = managed by Docker (`/var/lib/docker/volumes/...`).  
  - Bind mount = links a specific host directory (like `/home/.../data`).  

- **What’s a namespace?**  
  Kernel feature that isolates resources (pid, net, mnt, ipc, etc.). Each container gets its own.  

- **What’s a cgroup?**  
  Kernel feature that limits resources (CPU, memory, I/O).  

- **Why `mysqld_safe` in MariaDB?**  
  It’s a wrapper that starts `mysqld`, monitors it, and restarts it if it crashes.  

---

## 📝 Conclusion
This project is not only about Docker commands, but understanding **how containers work inside the Linux kernel**, and why we separate services into different containers.  
