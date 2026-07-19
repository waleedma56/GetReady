# GetReady

Handy ready-to-run shell scripts for quickly setting up and preparing Linux machines.

Each script is designed to be run **directly from a single link** — no cloning, no copying files around. Just paste one command on any Linux box and go.

> **Prerequisites:** `curl` or `wget` must be available on the system. On a truly minimal install you may need to install one first:
> ```bash
> apt update && apt install -y curl wget
> ```

---

## Quick start — the menu (recommended)

One command gives you a navigable checklist that scans your machine, shows what's already
installed (**green**) vs. missing (**red**), and lets you check/uncheck what to install:

```bash
curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/menu.sh | sudo bash
```

Controls:

- **Up / Down** arrows (or `k` / `j`) — move the highlight
- **Space** — check / uncheck the highlighted item
- **Enter** — activate the highlighted row (toggles an item, or triggers the buttons)
- **`[ Install selected ]`** button — installs everything that's checked
- **`[ System info ]`** button — shows the read-only [`info.sh`](#infosh) dashboard, then returns
- **`[ Exit ]`** button (or `q` / `Esc`) — quit

Missing items are pre-checked for you, so you can often just move to **`[ Install selected ]`**
and hit Enter. The menu reads keys from the terminal, so it stays interactive even through the
`curl | sudo bash` pipe (no `whiptail`/`dialog` needed — pure bash, runs anywhere).

---

## Scripts

### `essentials.sh`
Prepares a fresh **Proxmox / Ubuntu / Debian** system after a clean install: updates the
system, installs common CLI tools (curl, wget, git, vim, htop, zip/unzip, …) and networking
utilities (net-tools, nmap, dnsutils, tcpdump, …), then cleans up.

Run it in one line (needs root):

```bash
curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/essentials.sh | sudo bash
```

> `wget` alternative:
> ```bash
> wget -qO- https://raw.githubusercontent.com/waleedma56/GetReady/main/essentials.sh | sudo bash
> ```

### `users.sh`
Creates a new user with **SSH access** and **sudo privileges**. Prompts for username,
supports pasting public keys for authorized_keys, and optionally disables root SSH login.

```bash
curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/users.sh | sudo bash
```

> `wget` alternative:
> ```bash
> wget -qO- https://raw.githubusercontent.com/waleedma56/GetReady/main/users.sh | sudo bash
> ```

### `docker.sh`
Installs **Docker Engine + Docker Compose (v2 plugin)** on **Ubuntu / Debian** from Docker's
official apt repository, enables the service, adds your user to the `docker` group, then
**verifies** the install (`docker --version`, `docker compose version`, daemon check, and a
`hello-world` container smoke test).

```bash
curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/docker.sh | sudo bash
```

> `wget` alternative:
> ```bash
> wget -qO- https://raw.githubusercontent.com/waleedma56/GetReady/main/docker.sh | sudo bash
> ```

### `info.sh`
A **read-only** colorful system dashboard. At a glance it shows the hostname, OS &
kernel, uptime, CPU & load, memory and storage (with usage bars), network info
(interface IPs, gateway, DNS and public IP), plus Docker and logged-in-user status.
Makes **no changes** to the system and does **not** need root.

```bash
curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/info.sh | bash
```

> `wget` alternative:
> ```bash
> wget -qO- https://raw.githubusercontent.com/waleedma56/GetReady/main/info.sh | bash
> ```

---

## How the "single link" works

GitHub serves every file at a raw URL:

```
https://raw.githubusercontent.com/waleedma56/GetReady/main/<script>.sh
```

Piping that into `bash` runs it immediately. Because the repo is public, no login or token
is required on the target machine.

## Adding a new script

1. Drop a new `*.sh` file in this repo.
2. Commit and push.
3. It's instantly runnable via:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/<your-script>.sh | sudo bash
   ```

## Safety note

Piping a remote script straight into `bash` runs whatever the URL currently serves. Only do
this with repos you control (like this one). If you want to review first:

```bash
curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/essentials.sh -o essentials.sh
less essentials.sh      # read it
sudo bash essentials.sh # then run it
```
