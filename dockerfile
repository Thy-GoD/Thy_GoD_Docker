FROM kalilinux/kali-rolling

# Installs First Set of Packages.

# Environment Variables.
# Change the HOME variable if you wish to default to a non-root user.
# Change the HOME variable in the Tools.sh too.
# Change the EDITRO variable if you wish to use an alternative editor.

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

# Sets up PATH variables:

RUN echo '\nsource ~/.cargo/env' >> ~/.zshrc && \
    echo 'export PATH="/home/'${USER_ALT}'/.local/bin:${PATH}"' >> ~/.zshrc && \
    echo 'export PATH="/usr/games:${PATH}"\n' >> ~/.zshrc


# Sets Up Login Message (This can be easily configured)
# Hush login to remove default login warning.

RUN echo "\n#\!/bin/bash" > ~/.login_text && \
    echo "figlet -ct Thigh Terminal | lolcat" >> ~/.login_text && \
    echo "bash ~/.login_text\n" >> ~/.zshrc && \
    touch ~/.hushlogin 
    
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
# FYI zsh autocomplete is kinda buggy rn, so it's removed for now.

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
    echo '# znap source marlonrichert/zsh-autocomplete' >> ~/.zshrc && \
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
    echo '#Vanguard (Azur Lane) My Beloved.' >> /home/$USER_ALT/Vanguard_Worship_Alter/offering.sh && \
    echo "Replace login_text in ~/.login_text with the below line." >> /home/$USER_ALT/Vanguard_Worship_Alter/vanguard_greeting.txt && \
    echo "figlet -ct Vanguard My Beloved | lolcat" >> /home/$USER_ALT/Vanguard_Worship_Alter/vanguard_greeting.txt && \
    mkdir /home/$USER_ALT/Vanguard_Worship_Alter/Vanguard_Pics && \
    wget -P /home/$USER_ALT/Vanguard_Worship_Alter/Vanguard_Pics \
    https://cdn.donmai.us/sample/e9/75/__vanguard_and_vanguard_azur_lane_drawn_by_rock_lee7__sample-e9759b863a4c40aa3abc1428ffbe1fd9.jpg \
    https://cdn.donmai.us/sample/30/1a/__vanguard_and_vanguard_azur_lane_drawn_by_osatou_soul_of_sugar__sample-301a1a9ae09f6f158df56148c824c8ae.jpg \
    https://cdn.donmai.us/sample/21/ed/__vanguard_and_vanguard_azur_lane_drawn_by_junineu__sample-21ede8c155226916ee217a2f0a8a1e69.jpg \
    https://cdn.donmai.us/sample/ed/7a/__vanguard_and_vanguard_azur_lane_drawn_by_qiao_gongzi__sample-ed7a878c5d7c5f8800e9fc5300619103.jpg \
    https://cdn.donmai.us/original/6b/cc/__vanguard_and_vanguard_azur_lane_drawn_by_schreibe_shura__6bcc90093e21525f62516b2e8b0d57c1.jpg \
    https://cdn.donmai.us/original/f8/65/__vanguard_azur_lane_drawn_by_schreibe_shura__f865cde10cda4a3eb1328147fd3a7543.jpg
    
# Run the script to send the offerings.
    
RUN echo 'for file in /home/$USER_ALT/Vanguard_Worship_Alter/Vanguard_Pics/*; do \
    jp2a --colors $file --color-depth=8 --term-width -b >> /home/$USER_ALT/Vanguard_Worship_Alter/Vanguard_Appreciation_Post.txt; done' \
    >> /home/$USER_ALT/Vanguard_Worship_Alter/offering.sh && \
    chmod 777 /home/$USER_ALT/Vanguard_Worship_Alter/offering.sh

# Add Shared_Folder for volume mounting    

RUN mkdir ~/Shared_Folder
    
# Adds Custom Aliases

RUN echo "alias cls='clear && ls -l'" >> ~/.zshrc

# Install neovim and bat

RUN apt-get update && apt-get install -y \
    neovim \
    bat \
    && rm -rf /var/lib/apt/lists/*
    
# Sets up symlink for bat (Cat replacement) 

RUN mkdir -p ~/.local/bin && \
    ln -s /usr/bin/batcat ~/.local/bin/bat

# Starts setting up rust and crates.io
# For some reason, Cargo's Path variable doesn't seem to be set up properly.
# I have no idea what causes this as it wasn't an issue before.
# I may fix it in the future.
# Update: Problem was likely due to the home variable not being defined in the dockerfile.
# It has been fixed now.

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
    
# Cargo Installations
# Installs Xh, Ouch, Atuin,Cargo Updating Tool and Websocat, then binds atuin to zshrc.
# ~/.cargo/bin/cargo
RUN echo $PATH && \
    cargo install xh && \
    cargo install ouch && \
    cargo install atuin && \
    cargo install cargo-update && \
    cargo install --features=ssl websocat && \
    echo 'eval "$(atuin init zsh)"' >> ~/.zshrc

# Wordlists & Tools/Scripts
# Seclists will be the main wordlist, but you can add more here.
# Or, you can move/install seclists into here.
# Btw, use the command "seclists" to automatically move to the seclists dir.

# Update: Added directory for tools/scripts.
# This is to give github tools/scripts or POCs a special folder to live in <3.

RUN mkdir ~/Wordlists && \
    mkdir ~/Tools && \
    mkdir ~/Notes 

# Adds PSpy as an example tool.
# Change chmod value if you wish to use different perm values.

RUN wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64 -O ~/Tools/pspy64 && \
    chmod 777 ~/Tools/pspy64 


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
    && rm -rf /var/lib/apt/lists/*
        
# Does a final update of everything
# Includes SSH fix and automatic locatedb update.
    
RUN sudo apt-get update && apt-get upgrade -y && \
    sudo apt-get autoremove && \ 
    echo "MACs hmac-sha1" >> /etc/ssh/ssh_config && \
    echo "updatedb" >> ~/.zshrc

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
WORKDIR /root/

# Made By Thigh GoD with the help of Chat GPT and Googling.
