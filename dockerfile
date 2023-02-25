FROM docker.io/kalilinux/kali-rolling


# Set default shell to ZSH and install dependencies
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color
RUN apt-get update && apt-get install -y \
    zsh \
    sudo \
    git \
    wget \
    curl \
    build-essential \
    apt-utils \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-venv \
    python3-pip \
    mlocate \
    openssh-client \
    pkg-config \
    fonts-powerline \
    figlet \
    lsof \
    && rm -rf /var/lib/apt/lists/*
    
# Updates Everything (Will be done a second time)
    
RUN sudo apt-get update && apt-get upgrade -y
RUN apt-get autoremove
    
# Sets Up Login Message (This can be easily configured)

RUN echo "#!/bin/bash" > ~/.login_text && \
    echo "figlet -ct Thigh Terminal" >> ~/.login_text && \
    echo "bash ~/.login_text" >> ~/.zshrc

# Removes Core Dumps (Can comment out if you want them.)

RUN echo ulimit -c 0 >> ~/.zshrc

# Sets up Locate command.
    
RUN updatedb

# Add user "Thy_GoD" with sudo privileges
RUN useradd -m -G sudo -s /bin/zsh "Thy_GoD" \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
  
# Add Shared_Folder for volume mounting    
RUN mkdir /root/Shared_Folder

# Install ZSH snap & Plugins into zsh_files
RUN mkdir zsh_files/
RUN echo '# Download Znap, if it'\''s not there yet.' >> ~/.zshrc && \
    echo '[[ -f /root/zsh_files/Git/zsh-snap/znap.zsh ]] ||' >> ~/.zshrc && \
    echo '    git clone --depth 1 -- \' >> ~/.zshrc && \
    echo '        https://github.com/marlonrichert/zsh-snap.git /root/zsh_files/Git/zsh-snap' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo 'source /root/zsh_files/Git/zsh-snap/znap.zsh  # Start Znap' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap prompt` makes your prompt visible in just 15-40ms!' >> ~/.zshrc && \
    echo 'znap prompt spaceship-prompt/spaceship-prompt' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap source` automatically downloads and starts your plugins.' >> ~/.zshrc && \
    echo 'znap source marlonrichert/zsh-autocomplete' >> ~/.zshrc && \
    echo 'znap source zsh-users/zsh-syntax-highlighting' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap eval` caches and runs any kind of command output for you.' >> ~/.zshrc && \
    echo 'znap eval iterm2 '\''curl -fsSL https://iterm2.com/shell_integration/zsh'\''' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap function` lets you lazy-load features you don'\''t always need.' >> ~/.zshrc && \
    echo 'znap function _pyenv pyenv '\''eval "$( pyenv init - --no-rehash )"'\' >> ~/.zshrc && \
    echo 'compctl -K    _pyenv pyenv' >> ~/.zshrc

# Configures the spaceship prompt (Can be Changed)

RUN echo "SPACESHIP_HOST_SHOW='always'" > ~/.spaceshiprc.zsh && \
    echo "SPACESHIP_HOST_PREFIX='💀'" >> ~/.spaceshiprc.zsh && \
    echo "SPACESHIP_USER_SUFFIX=''" >> ~/.spaceshiprc.zsh && \
    echo "SPACESHIP_USER_COLOR='red'" >> ~/.spaceshiprc.zsh && \
    echo "SPACESHIP_DIR_TRUNC='0'" >> ~/.spaceshiprc.zsh && \
    echo "SPACESHIP_PROMPT_ORDER=(time user host dir git hg package node ruby python elm elixir xcode swift golang php rust haskell java julia docker aws gcloud venv conda dotnet kubectl terraform ibmcloud exec_time async line_sep battery jobs exit_code char)" >> ~/.spaceshiprc.zsh 

# Adds Custom Aliases

RUN echo "alias cls='clear && ls -a'" >> ~/.zshrc

# Install neovim and bat
RUN apt-get update && apt-get install -y \
    neovim \
    bat \
    && rm -rf /var/lib/apt/lists/*
    
# Sets up symlink for bat    
RUN mkdir -p ~/.local/bin && \
    ln -s /usr/bin/batcat ~/.local/bin/bat

# Starts setting up rust and crates.io

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="${PATH}:/root/.cargo/bin"

# Rock you/Wordlists
RUN mkdir /root/wordlists/
RUN git clone https://github.com/danielmiessler/SecLists.git /root/wordlists/

# Vulscan
RUN git clone https://github.com/scipag/vulscan /usr/share/nmap/scripts/vulscan

RUN mkdir /root/payloads

# installs Payloads and puts it into Payloads folder.
RUN git clone https://github.com/phoenix-journey/Payloads.git /tmp/Payloads \
    && mv /tmp/Payloads/* /root/payloads \
    && rm -rf /tmp/Payloads

# Cargo Installations
RUN cargo install xh && \
    cargo install ouch && \
    cargo install atuin && \
    echo 'eval "$(atuin init zsh)"' >> /root/.zshrc
    
# Above installs Xh, Ouch, Atuin, then binds atuin to zshrc.

# Install desired tools and open/bind ports
RUN apt-get update && apt-get install -y \
    python3 \
    iputils-ping \
    ncat \
    metasploit-framework \
    curl \
    wget \
    perl \
    git \
    feroxbuster \
    gobuster \
    tcpdump \
    nmap \
    smbmap \
    sqlmap \
    john \
    socat \
    hydra \
    hashcat \
    gnupg \
    wpscan \
    nikto \
    dnsutils \
    responder \
    amass \
    evil-winrm \
    crackmapexec \
    enum4linux \
    whois \
    w3m \
    jq \
    libncurses5-dev \
    libncursesw5-dev \
    libssl-dev \
    libffi-dev \
    perl \
    exploitdb \
    hashid \
    man-db \
    && rm -rf /var/lib/apt/lists/*
    
# Does a final update of everything
    
RUN sudo apt-get update && apt-get upgrade -y
RUN apt-get autoremove

# Signifies Ports to be Used.

EXPOSE 8888
EXPOSE 6969
EXPOSE 8889
EXPOSE 8080
EXPOSE 9090
EXPOSE 8585

# Set up additional configurations as needed
# ...

# Start as root
ENV PATH=/home/Thy_GoD/.local/bin:$PATH
USER "root"
WORKDIR /root/
CMD ["/bin/zsh"]

# Made By Thigh GoD with the help of Chat GPT and Googling.
