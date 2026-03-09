FROM nvidia/cuda:12.9.0-cudnn-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Python
    python3 python3-pip python3-dev \
    # Core utilities
    coreutils findutils grep sed gawk diffutils patch \
    less file tree bc man-db \
    # Networking
    curl wget net-tools iputils-ping dnsutils netcat-openbsd socat telnet \
    openssh-client rsync \
    # Editors
    vim nano \
    # Version control
    git \
    # Build tools
    build-essential cmake make \
    # Scripting & languages
    perl ruby-full lua5.4 \
    # Data processing
    jq xmlstarlet sqlite3 \
    # Media & documents
    ffmpeg pandoc imagemagick texlive-latex-base \
    # Compression
    zip unzip tar gzip bzip2 xz-utils zstd p7zip-full \
    # System
    procps htop lsof strace sysstat \
    sudo tmux screen \
    ca-certificates gnupg apt-transport-https \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    && rm -rf /var/lib/apt/lists/*

# Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Docker CLI + Compose + Buildx (mount socket at runtime for access)
RUN curl -fsSL https://get.docker.com | sh

WORKDIR /app

RUN pip install --no-cache-dir \
    numpy pandas scipy scikit-learn \
    matplotlib seaborn plotly \
    jupyter ipython \
    requests beautifulsoup4 lxml \
    sqlalchemy psycopg2-binary \
    pyyaml toml jsonlines \
    tqdm rich \
    openpyxl weasyprint \
    python-docx python-pptx pypdf csvkit

COPY . .
RUN pip install --no-cache-dir .

RUN useradd -m -s /bin/bash user && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user
ENV SHELL=/bin/bash
WORKDIR /home/user

EXPOSE 8000

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
