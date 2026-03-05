# ⚡ Open Terminal CUDA

A lightweight, self-hosted terminal that gives AI agents and automation tools a dedicated environment to run commands, manage files, and execute code — all through a simple API. This fork uses an **NVIDIA CUDA base image** to enable GPU-accelerated workloads inside the terminal environment.

## Why Open Terminal CUDA?

AI assistants are great at writing code, but they need somewhere to *run* it. Open Terminal CUDA is that place — a remote shell with file management, search, and more, accessible over a simple REST API. Unlike the upstream image, this fork is built on `nvidia/cuda`, giving every command and process inside the container full access to your NVIDIA GPU via CUDA and cuDNN.

You can run it two ways:

- **Docker (sandboxed)** — runs in an isolated container with a full toolkit pre-installed: Python, Node.js, git, build tools, data science libraries, ffmpeg, and more. Built on `nvidia/cuda` so GPU libraries (PyTorch, TensorFlow, CuPy, etc.) work out of the box. Great for giving AI agents a safe, GPU-capable playground without touching your host system.
- **Bare metal** — install it with `pip` and run it anywhere Python runs. Commands run directly on your machine with access to your real files, your real tools, and your real environment, perfect for local development, personal automation, or giving an AI assistant full access to your actual projects.

## Getting Started

### Docker (recommended)

> [!IMPORTANT]
> GPU access requires the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) to be installed on the Docker host. Pass `--gpus all` (or `--gpus '"device=0"'` for a specific GPU) to expose your NVIDIA GPU to the container.

```bash
docker run -d --name open-terminal-cuda --restart unless-stopped --gpus all \
  -p 8000:8000 -v open-terminal-cuda:/home/user \
  -e OPEN_TERMINAL_API_KEY=your-secret-key \
  ghcr.io/sechmachine727/open-terminal-cuda
```

That's it — you're up and running at `http://localhost:8000`. GPU libraries like PyTorch, TensorFlow, and CuPy that are installed inside the container can now use your NVIDIA GPU.

> [!TIP]
> If you don't set an API key, one is generated automatically. Grab it with `docker logs open-terminal-cuda`.

#### Customizing the Docker Environment

The default image ships with a broad set of tools, but you can tailor it to your needs. Fork the repo, edit the [Dockerfile](Dockerfile) to add or remove system packages, Python libraries, or language runtimes, then build your own image:

```bash
docker build -t my-terminal .
docker run -d --name open-terminal-cuda --gpus all -p 8000:8000 my-terminal
```

### Bare Metal

No Docker? No problem. Open Terminal CUDA is a standard Python package:

```bash
# One-liner with uvx (no install needed)
uvx open-terminal-cuda run --host 0.0.0.0 --port 8000 --api-key your-secret-key

# Or install globally with pip
pip install open-terminal-cuda
open-terminal-cuda run --host 0.0.0.0 --port 8000 --api-key your-secret-key
```

> [!CAUTION]
> On bare metal, commands run directly on your machine with your user's permissions. Use Docker if you want sandboxed execution.


## Configuration

Open Terminal CUDA can be configured via a TOML config file, environment variables, and CLI flags. Settings are resolved in this order (highest priority wins):

1. **CLI flags** (`--host`, `--port`, `--api-key`, etc.)
2. **Environment variables** (`OPEN_TERMINAL_API_KEY`, etc.)
3. **User config** — `$XDG_CONFIG_HOME/open-terminal-cuda/config.toml` (defaults to `~/.config/open-terminal-cuda/config.toml`)
4. **System config** — `/etc/open-terminal-cuda/config.toml`
5. **Built-in defaults**

Create a config file at either location with any of these keys (all optional):

```toml
host = "0.0.0.0"
port = 8000
api_key = "sk-my-secret-key"
cors_allowed_origins = "*"
log_dir = "/var/log/open-terminal-cuda"
binary_mime_prefixes = "image,audio"
execute_timeout = 5  # seconds to wait for command output (unset by default)
```

> [!TIP]
> Use the system config at `/etc/open-terminal-cuda/config.toml` to set site-wide defaults for host and port, and the user config for personal settings like the API key — this keeps the key out of `ps` / `htop`.

You can also point to a specific config file:

```bash
open-terminal-cuda run --config /path/to/my-config.toml
```

## Using with Open WebUI

Open Terminal CUDA integrates with [Open WebUI](https://github.com/open-webui/open-webui), giving your AI assistants the ability to run commands, manage files, and interact with a terminal right from the AI interface. Make sure to add it under **Open Terminal** in the integrations settings, not as a tool server. Adding it as an Open Terminal connection gives you a built-in file navigation sidebar where you can browse directories, upload, download, and edit files. There are two ways to connect:

### Direct Connection

Users can connect their own Open Terminal instance from their user settings. This is useful when the terminal is running on their local machine or a network only they can reach, since requests go directly from the **browser**.

1. Go to **User Settings → Integrations → Open Terminal**
2. Add the terminal **URL** and **API key**
3. Enable the connection

### System-Level Connection

Admins can configure Open Terminal connections for their users from the admin panel. Multiple terminals can be set up with access controlled at the user or group level. Requests are proxied through the Open WebUI **backend**, so the terminal only needs to be reachable from the server.

1. Go to **Admin Settings → Integrations → Open Terminal**
2. Add the terminal **URL** and **API key**
3. Enable the connection

For isolated, per-user terminal containers, see **[Terminals](https://github.com/open-webui/terminals)**, which requires an enterprise license for production use.

## API Docs

Full interactive API documentation is available at [http://localhost:8000/docs](http://localhost:8000/docs) once your instance is running.

## Star History

<a href="https://star-history.com/#sechmachine727/open-terminal-cuda&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=sechmachine727/open-terminal-cuda&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=sechmachine727/open-terminal-cuda&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=sechmachine727/open-terminal-cuda&type=Date" />
  </picture>
</a>

> [!TIP]
> **Need multi-tenant?** Check out **[Terminals](https://github.com/open-webui/terminals)**, which provisions and manages isolated Open Terminal containers per user with a single authenticated API entry point.

## License

MIT — see [LICENSE](LICENSE) for details.
