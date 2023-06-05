FROM kalilinux/kali-rolling

# Installs First Set of Packages.

# Environment Variables.
# Change the HOME variable if you wish to default to a non-root user.
# Change the HOME variable in the Tools.sh too.
# Change the EDITOR variable if you wish to use an alternative editor.

ENV USER_ALT=Thy_GoD
ENV TERM=xterm-256color
ENV SHELL=/bin/zsh
ENV HOME=/root
ENV PATH="${PATH}:${HOME}/.cargo/bin"
ENV EDITOR=/usr/bin/nvim

# Core Tools

RUN apt-get update && apt-get install -y \
    zsh \
    sudo \
    git \
    wget \
    curl \
    apt-utils \
    build-essential

# Switch shell to zsh.

SHELL ["/bin/zsh", "-c"] 

# Core Packages

RUN apt-get update && apt-get install -y \
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
    jp2a \
    lolcat \
    && rm -rf /var/lib/apt/lists/*
    
# Updates Everything (Will be done a second time)
    
RUN sudo apt-get update && apt-get upgrade -y
RUN sudo apt-get autoremove

# Installs Glow (Yeah I know, weird spot to put this.)
RUN curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list && \
    sudo apt-get update && apt-get install -y glow
    
# Add user "Thy_GoD" with sudo privileges 
# This was done mainly for fun,
# If you need a "work" folder and "home" folder.
# If you wish to change the username, please change the USER_ALT variable somewhere on top ^

RUN useradd -m -G sudo -s /bin/zsh "$USER_ALT" \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Add Worshipping Alter For My Beloved Vanguard (Azur Lane)  
# P.S this can be changed to be any worship alter, be it frogs, eggs, beans, or ur mom.
# Btw, the images shown are not mine, I do not own them.
# I will give the sauce to where they can be found, though.
  
# Image 1: https://www.pixiv.net/artworks/99903167 - Rock-lee7
# Image 2: https://www.pixiv.net/artworks/98796485 - Osatou
# Image 3: https://www.pixiv.net/artworks/98573430 - Junineu
# Image 4: https://www.pixiv.net/artworks/99683976 - Qiao GongZi
# Image 5: https://www.pixiv.net/artworks/98670137 - Schreibe Shura
# Image 6: https://www.pixiv.net/artworks/98791548 - Schreibe Shura
  
RUN mkdir /home/$USER_ALT/Vanguard_Worship_Alter && \
    mkdir /home/$USER_ALT/Vanguard_Worship_Alter/Vanguard_Pics && \
    wget -P /home/$USER_ALT/Vanguard_Worship_Alter/Vanguard_Pics \
    https://cdn.donmai.us/sample/e9/75/__vanguard_and_vanguard_azur_lane_drawn_by_rock_lee7__sample-e9759b863a4c40aa3abc1428ffbe1fd9.jpg \
    https://cdn.donmai.us/sample/30/1a/__vanguard_and_vanguard_azur_lane_drawn_by_osatou_soul_of_sugar__sample-301a1a9ae09f6f158df56148c824c8ae.jpg \
    https://cdn.donmai.us/sample/21/ed/__vanguard_and_vanguard_azur_lane_drawn_by_junineu__sample-21ede8c155226916ee217a2f0a8a1e69.jpg \
    https://cdn.donmai.us/sample/ed/7a/__vanguard_and_vanguard_azur_lane_drawn_by_qiao_gongzi__sample-ed7a878c5d7c5f8800e9fc5300619103.jpg \
    https://cdn.donmai.us/original/6b/cc/__vanguard_and_vanguard_azur_lane_drawn_by_schreibe_shura__6bcc90093e21525f62516b2e8b0d57c1.jpg \
    https://cdn.donmai.us/original/f8/65/__vanguard_azur_lane_drawn_by_schreibe_shura__f865cde10cda4a3eb1328147fd3a7543.jpg

# Add Shared_Folder for volume mounting    

RUN mkdir ~/Shared_Folder

# Install neovim and bat

RUN apt-get update && apt-get install -y \
    neovim \
    bat \
    && rm -rf /var/lib/apt/lists/*
    
# Sets up symlink for bat (Cat replacement) 

RUN mkdir -p ~/.local/bin && \
    ln -s /usr/bin/batcat ~/.local/bin/bat

# Starts setting up rust and crates.io

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
    
# Cargo Installations
# Installs Xh, Ouch, Atuin,Cargo Updating Tool and Websocat, then binds atuin to zshrc.

RUN cargo install xh && \
    cargo install ouch && \
    cargo install atuin && \
    cargo install cargo-update && \
    cargo install --features=ssl websocat

# Wordlists & Tools/Scripts
# Seclists will be the main wordlist, but you can add more here.
# Or, you can move/install seclists into here.
# Btw, use the command "seclists" to automatically move to the seclists dir.

# Update: Added directory for tools/scripts.
# This is to give github tools/scripts or POCs a special folder to live in <3.

RUN mkdir ~/Wordlists && \
    mkdir ~/Tools && \
    mkdir ~/Notes 

# Adds PSpy & Linpeas as an example tool.
# Change chmod value if you wish to use different perm values.

RUN wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64 -O ~/Tools/pspy64 && \
    wget https://github.com/carlospolop/PEASS-ng/releases/download/20230425-bd7331ea/linpeas.sh -P ~/Tools/linpeas.sh && \
    chmod 777 ~/Tools/pspy64 && \
    chmod 777 ~/Tools/linpeas.sh

# Vulscan

RUN git clone https://github.com/scipag/vulscan /usr/share/nmap/scripts/vulscan

# Installs Payloads into Payloads folder.

RUN mkdir ~/Payloads/
RUN git clone https://github.com/phoenix-journey/Payloads.git ~/Payloads/Payloads-Github

# Installs Python tools with pipx:

RUN pipx install impacket

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
    perl \
    exploitdb \
    hashid \
    man-db \
    mitmproxy \
    ffuf \
    crunch \
    tmux \
    ftp \
    webshells \
    ranger \
    chisel \
    tshark \
    pwncat \
    && rm -rf /var/lib/apt/lists/*
        
# Does a final update of everything
# Includes SSH fix and any other future fixes.
    
RUN sudo apt-get update && apt-get upgrade -y && \
    sudo apt-get autoremove && \ 
    echo "MACs hmac-sha1" >> /etc/ssh/ssh_config
    
# Transfers Over All The Config Files.
# Add Chown Perms for Alt User

COPY Config/.* ${HOME}/
COPY --chown=${USER_ALT}:${USER_ALT} Config/.* /home/${USER_ALT}/
COPY --chown=${USER_ALT}:${USER_ALT} Config/Vanguard_Worship_Files/* /home/${USER_ALT}/Vanguard_Worship_Alter/

# Sets Execute Perms on offering script.
    
RUN chmod 777 /home/$USER_ALT/Vanguard_Worship_Alter/Offering.sh

# Signifies Ports to be Used. 
# (21 for ftp, 22 for SSH, 80 for HTTP, 443 for HTTPS, 445 for SMB, 8080 for MITMProxy)
# Rest are extras for MISC usages. 

EXPOSE 21
EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 445
EXPOSE 6969
EXPOSE 8081
EXPOSE 8080
EXPOSE 8585
EXPOSE 8888
EXPOSE 8889
EXPOSE 9090

# Set up additional configurations as needed
# I recommend package managers if you need them like npm or brew,
# It's a matter of preference, plus you can add and remove stuff as you wish.
# ...
# RUN sudo apt-get install gobuster
# Gobuster was removed as I found ffuf to be better, you can revert these changes. 

# Start as root (Can be changed)
USER "root"
WORKDIR /root

# Made By Thigh GoD with the help of Chat GPT and Googling.
