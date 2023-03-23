FROM kalilinux/kali-rolling

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
    pipx \
    mlocate \
    openssh-client \
    pkg-config \
    fonts-powerline \
    figlet \
    lsof \
    hurl \
    seclists \
    && rm -rf /var/lib/apt/lists/*
    
# Updates Everything (Will be done a second time)
    
RUN sudo apt-get update && apt-get upgrade -y
RUN sudo apt-get autoremove

# Sets Up Login Message (This can be easily configured)

RUN echo "\n#\!/bin/bash" > ~/.login_text && \
    echo "figlet -ct Thigh Terminal" >> ~/.login_text && \
    echo "bash ~/.login_text\n" >> ~/.zshrc
    
# Sets up PATH variables:

run echo 'export PATH="${PATH}:${HOME}/.cargo/bin"' >> ~/.zshrc && \
    echo 'export PATH="/home/Thy_GoD/.local/bin:${PATH}"\n' >> ~/.zshrc
    
# Removes Core Dumps (Can comment out if you want them.)

RUN echo "ulimit -c 0" >> ~/.zshrc

# Sets up Oh-My-ZSH.
# Plugins included are autocomplete, syntax highlight and atuin (installed later).
# This script automatically installs and runs my personal Prompt, you may change if you wish.
# This script has also been deprecated as it was slow, I am utilizing both Oh My ZSH and znap now.

#RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -) --unattended" && \
#    echo "#Customized Settings, use the template if you need to change." > ~/.zshrc && \
#    echo "export ZSH=$HOME/.oh-my-zsh" >> ~/.zshrc && \
#    echo "ZSH_THEME='ThyGoD'" >> ~/.zshrc && \
#    echo "zstyle ':omz:update' mode auto   # update automatically without asking" >> ~/.zshrc && \
#    echo "zstyle ':omz:update' frequency 7 # update every week" >> ~/.zshrc && \
#    echo "zstyle ':autocomplete:*' min-input 3" >> ~/.zshrc && \
#    echo "plugins=(git-prompt zsh-syntax-highlighting zsh-autocomplete)" >> ~/.zshrc && \
#    echo "source $HOME/.oh-my-zsh/oh-my-zsh.sh" >> ~/.zshrc && \
#    git clone https://github.com/Thy-GoD/thy-god-zsh-theme.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/Thy-GoD && \
#    cp ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/Thy-GoD/ThyGoD.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/ && \
#    git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete && \
#    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \

# Original ZSH Configuration.
# Install ZSH snap & Plugins into zsh_files.
# znap has been removed as I switched to Oh-My-Zsh.
# Update: Znap has been Merged with Oh-My-Zsh for faster loading time.

#RUN mkdir ~/zsh_files
#RUN echo '# Download Znap, if it'\''s not there yet.' >> ~/.zshrc && \
#    echo '[[ -f /root/zsh_files/Git/zsh-snap/znap.zsh ]] ||' >> ~/.zshrc && \
#    echo '    git clone --depth 1 -- \' >> ~/.zshrc && \
#    echo '        https://github.com/marlonrichert/zsh-snap.git /root/zsh_files/Git/zsh-snap' >> ~/.zshrc && \
#    echo '' >> ~/.zshrc && \
#    echo 'source /root/zsh_files/Git/zsh-snap/znap.zsh  # Start Znap' >> ~/.zshrc && \
#    echo '' >> ~/.zshrc && \
#    echo '# `znap prompt` makes your prompt visible in just 15-40ms!' >> ~/.zshrc && \
#    echo 'znap prompt spaceship-prompt/spaceship-prompt' >> ~/.zshrc && \
#    echo '' >> ~/.zshrc && \
#    echo '# `znap source` automatically downloads and starts your plugins.' >> ~/.zshrc && \
#    echo 'znap source marlonrichert/zsh-autocomplete' >> ~/.zshrc && \
#    echo 'znap source zsh-users/zsh-syntax-highlighting' >> ~/.zshrc && \
#    echo '' >> ~/.zshrc && \
#    echo '# `znap eval` caches and runs any kind of command output for you.' >> ~/.zshrc && \
#    echo 'znap eval iterm2 '\''curl -fsSL https://iterm2.com/shell_integration/zsh'\''' >> ~/.zshrc && \
#    echo '' >> ~/.zshrc && \
#    echo '# `znap function` lets you lazy-load features you don'\''t always need.' >> ~/.zshrc && \
#    echo 'znap function _pyenv pyenv '\''eval "$( pyenv init - --no-rehash )"'\' >> ~/.zshrc && \
#    echo 'compctl -K    _pyenv pyenv' >> ~/.zshrc && \
#    echo "zstyle ':autocomplete:*' min-input 3" >> ~/.zshrc
    
# Configures the spaceship prompt (Can be Changed)
# Spaceship prompt has been archived, I made my own ZSH theme. (https://github.com/Thy-GoD/thy-god-zsh-theme)

#RUN echo "SPACESHIP_HOST_SHOW='always'" > ~/.spaceshiprc.zsh && \
#    echo "SPACESHIP_HOST_PREFIX='💀'" >> ~/.spaceshiprc.zsh && \
#    echo "SPACESHIP_USER_SUFFIX=''" >> ~/.spaceshiprc.zsh && \
#    echo "SPACESHIP_USER_COLOR='red'" >> ~/.spaceshiprc.zsh && \
#    echo "SPACESHIP_DIR_TRUNC='0'" >> ~/.spaceshiprc.zsh && \
#    echo "SPACESHIP_PROMPT_ORDER=(time user host dir git hg package node ruby python elm elixir xcode swift golang php rust haskell java julia docker aws gcloud venv conda dotnet kubectl terraform ibmcloud exec_time async line_sep battery jobs exit_code char)" >> ~/.spaceshiprc.zsh 

# Sets up znap with Oh My ZSH installed. (With my personal prompt.)

RUN \
    echo '\n# Downloads Znap' >> ~/.zshrc && \
    echo '[[ -f ~/.ZSH_FILES/Git/zsh-snap/znap.zsh ]] ||' >> ~/.zshrc && \
    echo '    git clone --depth 1 -- \' >> ~/.zshrc && \
    echo '        https://github.com/marlonrichert/zsh-snap.git ~/.ZSH_FILES/Git/zsh-snap' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo 'source ~/.ZSH_FILES/Git/zsh-snap/znap.zsh  # Start Znap' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo 'znap source ohmyzsh/ohmyzsh lib/{git,theme-and-appearance} # Required by OMZ prompt' >> ~/.zshrc && \
    echo 'znap source ohmyzsh/ohmyzsh plugins/git-prompt # plugin used by my theme' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap prompt` makes your prompt visible in just 15-40ms!' >> ~/.zshrc && \
    echo 'znap prompt Thy-GoD/thy-god-zsh-theme ThyGoD' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap source` automatically downloads and starts your plugins.' >> ~/.zshrc && \
    echo 'znap source marlonrichert/zsh-autocomplete' >> ~/.zshrc && \
    echo 'znap source zsh-users/zsh-syntax-highlighting' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap eval` caches and runs any kind of command output for you.' >> ~/.zshrc && \
    echo 'znap eval iterm2 '\'"curl -fsSL https://iterm2.com/shell_integration/zsh"\' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# `znap function` lets you lazy-load features you wont always need.' >> ~/.zshrc && \
    echo 'znap function _pyenv pyenv '\''eval "$( pyenv init - --no-rehash )"'\' >> ~/.zshrc && \
    echo 'compctl -K    _pyenv pyenv' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo "zstyle ':autocomplete:*' min-input 3" >> ~/.zshrc

# Add user "Thy_GoD" with sudo privileges 
# This was done mainly for fun,
# If you need a "work" folder and "home" folder.
# If you wish to change the username, please change the PATH variable somewhere on top ^
# I will find a way to fix this at some point.

RUN useradd -m -G sudo -s /bin/zsh "Thy_GoD" \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    
RUN mkdir /home/Thy_GoD/Vanguard_Worship_Alter && \
    echo 'Vanguard (Azur Lane) My Beloved.' >> /home/Thy_GoD/Vanguard_Worship_Alter/offering.txt && \
    echo "Add the below line to ~/.login_text" >> /home/Thy_GoD/Vanguard_Worship_Alter/vanguard_greeting.txt && \
    echo "figlet -ct Vanguard My Beloved" >> /home/Thy_GoD/Vanguard_Worship_Alter/vanguard_greeting.txt
    
# Add Shared_Folder for volume mounting    

RUN mkdir ~/Shared_Folder
    
# Adds Custom Aliases

RUN echo "alias cls='clear && ls -l'" >> ~/.zshrc

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

# Wordlists & Tools/Scripts
# Seclists will be the main wordlist, but you can add more here.
# Or, you can move/install seclists into here.
# Btw, use the command "seclists" to automatically move to the seclists dir.

# Update: Added directory for tools/scripts.
# This is to give github tools/scripts or POCs a special folder to live in <3.

RUN mkdir /root/wordlists
RUN mkdir /root/tools


# Vulscan

RUN git clone https://github.com/scipag/vulscan /usr/share/nmap/scripts/vulscan

# Installs Payloads into payloads folder.

RUN mkdir ~/payloads/
RUN git clone https://github.com/phoenix-journey/Payloads.git ~/payloads/Payloads

# Cargo Installations
# Installs Xh, Ouch, Atuin,Cargo Updating Tool and Websocat, then binds atuin to zshrc.

RUN cargo install xh && \
    cargo install ouch && \
    cargo install atuin && \
    cargo install cargo-update && \
    cargo install --features=ssl websocat && \
    echo 'eval "$(atuin init zsh)"' >> ~/.zshrc
    
# Install Tools and Open Planned Ports

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
    mitmproxy \
    ffuf \
    crunch \
    && rm -rf /var/lib/apt/lists/*
    
# Does a final update of everything
# Includes SSH fix and automatic locatedb update.
    
RUN sudo apt-get update && apt-get upgrade -y && \
    sudo apt-get autoremove && \ 
    echo "MACs hmac-sha1" >> /etc/ssh/ssh_config && \
    echo "updatedb" >> ~/.zshrc

# Signifies Ports to be Used. (8080 for MITMProxy, 443 for HTTPS, 80 for HTTP)

EXPOSE 80
EXPOSE 443
EXPOSE 8888
EXPOSE 6969
EXPOSE 8889
EXPOSE 8080
EXPOSE 9090
EXPOSE 8585

# Set up additional configurations as needed
# I recommend package managers if you need them like npm or brew,
# It's a matter of preference, plus you can add and remove stuff as you wish.
# ...
# RUN sudo apt-get install gobuster
# Gobuster was removed as I found ffuf to be better, you can revert these changes. 

# Start as root
ENV PATH=/home/Thy_GoD/.local/bin:$PATH
USER "root"
WORKDIR /root/
CMD zsh

# Made By Thigh GoD with the help of Chat GPT and Googling.
