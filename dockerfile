FROM kalilinux/kali-rolling

# Installs First Set of Packages.

# Environment Variables.
# Change the HOME variable if you wish to default to a non-root user.
# Change the HOME variable in the Tools.sh too.
# Change the EDITOR variable if you wish to use an alternative editor.
# Change the TZ variable if you're not in Singapore (Very Likely).

ENV USER_ALT=Thy_GoD
ENV TERM=xterm-256color
ENV SHELL=/bin/zsh
ENV HOME=/root
ENV PATH="${HOME}/.local/share/nvim/bin:${PATH}:${HOME}/.cargo/bin"
ENV EDITOR="${HOME}/.local/share/nvim/bin/nvim"
ENV TZ="Asia/Singapore"
ENV GOPATH="${HOME}/.go"

# Core Tools

RUN apt-get update && apt-get install -y \
    zsh \
    sudo \
    git \
    wget \
    curl \
    apt-utils \
    iproute2 \
    build-essential \
    libkrb5-dev \
    chromium

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
    locate \
    openssh-client \
    pkg-config \
    fonts-powerline \
    figlet \
    lsof \
    hurl \
    seclists \
    jp2a \
    lolcat \
    golang \
    feh \
    freerdp2-x11 \
    lua5.4\
    burpsuite \
    villain \
    sqlmap \
    faketime \
    && rm -rf /var/lib/apt/lists/*
    
# Updates Everything (Will be done a second time)
    
RUN sudo apt-get update && apt-get upgrade -y
RUN sudo apt-get autoremove

# Installs Glow (Yeah I know, weird spot to put this.)
RUN curl --retry-all-errors --retry 5 -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg && \
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
    wget --user-agent Chrome -P /home/$USER_ALT/Vanguard_Worship_Alter/Vanguard_Pics \
    https://cdn.donmai.us/sample/e9/75/__vanguard_and_vanguard_azur_lane_drawn_by_rock_lee7__sample-e9759b863a4c40aa3abc1428ffbe1fd9.jpg \
    https://cdn.donmai.us/sample/30/1a/__vanguard_and_vanguard_azur_lane_drawn_by_osatou_soul_of_sugar__sample-301a1a9ae09f6f158df56148c824c8ae.jpg \
    https://cdn.donmai.us/sample/21/ed/__vanguard_and_vanguard_azur_lane_drawn_by_junineu__sample-21ede8c155226916ee217a2f0a8a1e69.jpg \
    https://cdn.donmai.us/sample/ed/7a/__vanguard_and_vanguard_azur_lane_drawn_by_qiao_gongzi__sample-ed7a878c5d7c5f8800e9fc5300619103.jpg \
    https://cdn.donmai.us/original/6b/cc/__vanguard_and_vanguard_azur_lane_drawn_by_schreibe_shura__6bcc90093e21525f62516b2e8b0d57c1.jpg \
    https://cdn.donmai.us/original/f8/65/__vanguard_azur_lane_drawn_by_schreibe_shura__f865cde10cda4a3eb1328147fd3a7543.jpg

# Add Shared_Folder for volume mounting    

RUN mkdir ~/Shared_Folder

# Starts setting up rust and crates.io

RUN curl --retry-all-errors --retry 5 https://sh.rustup.rs -sSf | sh -s -- -y
    
# Cargo Installations
# Installs Ouch, Atuin,Cargo Updating Tool and Websocat, then binds atuin to zshrc.
# Ouch: unzip replacement 
# atuin: Terminal History replacement
# cargo-update: makes updating easier, use cargo-update all
# rustcat: allows automatic dumb shell upgrades.
# Removed xh installation as I've never needed to use it.
# P.S rust in Docker containers r kinda buggy, you'll need to uninstall and re-install the toolchain if you want to update it.

RUN cargo install ouch && \
    cargo install atuin && \
    cargo install cargo-update && \
    cargo install --features=ssl websocat && \
    cargo install rustcat

# Wordlists & Tools/Scripts
# Seclists will be the main wordlist, but you can add more here.
# Or, you can move/install seclists into here.
# Btw, use the command "seclists" to automatically move to the seclists dir.

# Update: Added directory for tools/scripts.
# This is to give github tools/scripts or POCs a special folder to live in <3.
# Added directories in Tools folder

RUN mkdir ~/Wordlists && \
    mkdir ~/Tools && \
    mkdir ~/Tools/DIY_Tools && \
    mkdir ~/Notes && \
    mkdir ~/Tools/reconftw_tools
    
# Vulscan

RUN git clone https://github.com/scipag/vulscan /usr/share/nmap/scripts/vulscan

# Creates Payloads folder.
# Payload repo was removed due to deprecation.
# Adds POC and msfvenom payload folders

RUN mkdir ~/Payloads && mkdir ~/Payloads/PoC && mkdir ~/Payloads/msfvenom

# Adds PSpy an example tool.
# Linpeas/Winpeas has been removed as a default tool due to peass package.
# Change chmod value if you wish to use different perm values.

RUN latest=$(curl --retry-all-errors --retry 5 -IL -s https://github.com/DominicBreuker/pspy/releases/latest | sed -n /location:/p | cut -d ' ' -f 2 | tr -d '\r\n') && \
    latest=$(echo "${latest/tag/download}") && \
    latest+="/pspy64" && \
    wget -O pspy64 ${latest} && \
    mv pspy64 ~/Payloads/ && \
    chmod 777 ~/Payloads/pspy64

# Removed impacket installation as it was not needed.

# Install neovim (Yes I made a whole section just for Neovim lmao)
# Batcat has been removed in favor of neovim.
# Update: Debian package does not have the updated neovim version, 
# I have changed the installation method to obtain from repo release.

RUN latest_release=$(curl --retry-all-errors --retry 5 -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -oP '"tag_name": "\K(.*?)(?=")') && \
    file_name="nvim-linux64.tar.gz" && \
    download_url="https://github.com/neovim/neovim/releases/download/$latest_release/${file_name}" && \
    wget -O "nvim.tar.gz" "${download_url}" && \
    ouch decompress "nvim.tar.gz" && \
    rm "nvim.tar.gz"

# Installs Tmux Theme:

RUN git clone https://github.com/wfxr/tmux-power.git ~/.tmux/themes/

# Install Villain (Thanks to the Creator for noticing my feature request)
# This has been deprecated as it's possible to install it via apt now.
# Congratulations to the creator for having their project recognized!

#RUN git clone https://github.com/t3l3machus/Villain.git ~/Tools/Villain && \
#    pip3 install -r ~/Tools/Villain/requirements.txt 2>/dev/null 1>/dev/null && \
#    chmod 777 ~/Tools/Villain/Villain.py
    
# Install git dumper

RUN git clone https://github.com/arthaud/git-dumper.git ~/Tools/git-dumper && \
    pip3 install -r ~/Tools/git-dumper/requirements.txt 2>/dev/null 1>/dev/null && \
    chmod 777 ~/Tools/git-dumper/git_dumper.py
    
# Installs powerview.py (Thanks to the creator for troubleshooting a problem I had w the script.)

RUN git clone https://github.com/aniqfakhrul/powerview.py.git ~/Tools/powerview.py && \
    pip3 install -r ~/Tools/powerview.py/requirements.txt 2>/dev/null 1>/dev/null && \
    chmod 777 ~/Tools/powerview.py/powerview.py
    
# Installs Pretender (Updated mitm6)
# You will need to move the tool to the shared folder in order to use it.
# Ofc if you run --network=host, this could be used from within the container itself.
# If I find a way to make it work without --network=host, I will update it.
# Good news, I managed to get both LLMNR and DHCPv6 working from a docker container.
# This tool is now disabled in favor of Inveigh

# RUN git clone https://github.com/RedTeamPentesting/pretender.git ~/Tools/pretender && \
# go build -C ~/Tools/pretender/ -ldflags '-X main.vendorInterface=eth0'
    
# Install NeoVim plugin manager.

RUN sh -c 'curl --retry-all-errors --retry 5 -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Installs Bearer for code analysis.
RUN apt-get install apt-transport-https && \
    echo "deb [trusted=yes] https://apt.fury.io/bearer/ /" > /etc/apt/sources.list.d/fury.list && \
    apt-get update && apt-get install bearer -y

# Installs Bloodhound (Update: Python bloodhound and CME's bloodhound module only work with BloodhoundAD, it will be re-added.)

#RUN latest=$(curl -IL -s https://github.com/BloodHoundAD/SharpHound/releases/latest | awk -F'/' '/location:/ { print $NF }' | tr -d '\r\n') && \
#    latest="${latest/tag/download}" && \
#    version=$(echo "$latest" | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?)\.zip/\1/') && \
#    download_link="https://github.com/BloodHoundAD/SharpHound/releases/download/${latest}/SharpHound-${version}.zip" && \
#    wget -O SharpHound.zip "$download_link" && \
#    unzip SharpHound.zip -d ~/Payloads/ && \
#    rm SharpHound.zip

# Install jwt-token tool

RUN git clone https://github.com/ticarpi/jwt_tool.git ~/Tools/jwt_tool && \
    pip3 install -r ~/Tools/jwt_tool/requirements.txt 2>/dev/null 1>/dev/null && \
    chmod 777 ~/Tools/jwt_tool/jwt_tool.py
    
# Install webpack unpacker
# this tool has been abandoned and is planned to be purged, I will archive it out of respect.

#RUN git clone https://github.com/rarecoil/unwebpack-sourcemap.git ~/Tools/unwebpack-sourcemap && \
#    pip3 install -r ~/Tools/unwebpack-sourcemap/requirements.txt 2>/dev/null 1>/dev/null && \
#    chmod 777 ~/Tools/unwebpack-sourcemap/unwebpack_sourcemap.py
    
# Install ligolo-ng (Pivoting/Tunneling Tool)
# I've also added in the Windows versions as well.
# I really do love this tool, and I'll promote @opcode (https://gitlab.com/0pcode) for helping me out w this tool. <3

RUN git clone https://github.com/nicocha30/ligolo-ng.git ~/Tools/ligolo-ng && \
    go build -C ~/Tools/ligolo-ng/cmd/proxy/ -o ligolo-proxy && mv ~/Tools/ligolo-ng/cmd/proxy/ligolo-proxy ~/Tools/ligolo-ng && \
    go build -C ~/Tools/ligolo-ng/cmd/agent/ -o ligolo-agent && mv ~/Tools/ligolo-ng/cmd/agent/ligolo-agent ~/Tools/ligolo-ng && \
    GOOS=windows go build -C ~/Tools/ligolo-ng/cmd/proxy/ -o ligolo-proxy.exe && mv ~/Tools/ligolo-ng/cmd/proxy/ligolo-proxy.exe ~/Tools/ligolo-ng && \
    GOOS=windows go build -C ~/Tools/ligolo-ng/cmd/agent/ -o ligolo-agent.exe && mv ~/Tools/ligolo-ng/cmd/agent/ligolo-agent.exe ~/Tools/ligolo-ng

# Installs Chisel (ligolo-ng does not have local port forwarding....somehow.)
# Update: As of 25/2/2024, ligolo-ng has added in local port forwarding, which I will test out and remove chisel if needed.

RUN curl --retry-all-errors --retry 5 https://i.jpillora.com/chisel! | bash && \
    latest_release=$(curl --retry-all-errors --retry 5 -s "https://api.github.com/repos/jpillora/chisel/releases/latest" | grep -oP '"tag_name": "\K(.*?)(?=")') && \
    file_name="chisel_${latest_release#v}_windows_amd64.gz" && \
    download_url="https://github.com/jpillora/chisel/releases/download/$latest_release/${file_name}" && \
    wget -O "chisel.exe.gz" "${download_url}" && \
    gunzip "chisel.exe.gz" && \
    mv "chisel.exe" ~/Payloads

# Installs Pass The Cert, this is as sometimes certipy will break/stop working.
# I have removed this installation as SharpCollection includes it's .exe version.

#RUN git clone https://github.com/AlmondOffSec/PassTheCert.git ~/Tools/PassTheCert && \
#    chmod 777 ~/Tools/PassTheCert/Python/passthecert.py
    
# Installs username-anarchy, a tool that generates usernames from a list of people's names for you.
RUN git clone https://github.com/urbanadventurer/username-anarchy.git ~/Tools/username-anarchy && \
    chmod 777 ~/Tools/username-anarchy/username-anarchy
    
# Installs ConPtyShell

RUN wget https://raw.githubusercontent.com/antonioCoco/ConPtyShell/master/Invoke-ConPtyShell.ps1 && \
    mv Invoke-ConPtyShell.ps1 ~/Payloads

# Installs FullPowers

RUN wget https://github.com/itm4n/FullPowers/releases/download/v0.1/FullPowers.exe && \
    mv FullPowers.exe ~/Payloads/PoC

# Installs GodPotato

RUN latest_release=$(curl --retry-all-errors --retry 5 -s "https://api.github.com/repos/BeichenDream/GodPotato/releases/latest" | grep -o '"tag_name": ".*"' | cut -d'"' -f4) && \
    download_url="https://github.com/BeichenDream/GodPotato/releases/download/$latest_release/GodPotato-NET4.exe" && \
    wget -O "GodPotato.exe" "$download_url" && \
    mv GodPotato.exe ~/Payloads/PoC
    
# Installs Ngrok (Proxy through internet to localhost)

RUN curl --retry-all-errors --retry 5 -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && \
    sudo apt update && sudo apt upgrade -y && sudo apt install ngrok

# Installs Inveigh.exe and Inveigh (Linux). 
# This lets you run responder on both windows (post-compromise and on this container.)
# Please look at the README.md for instructions on how to enable multicast forwarding.
# Inveigh.exe has been removed as it's part of the SharpCollection repo.

RUN latest=$(curl --retry-all-errors --retry 5 -IL -s https://github.com/Kevin-Robertson/Inveigh/releases/latest | awk -F'/' '/location:/ { print $NF }' | tr -d '\r\n') && \   
    latest="${latest/tag/download}" && \
    version=$(echo "$latest" | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?)\.zip/\1/') && \
    download_link="https://github.com/Kevin-Robertson/Inveigh/releases/download/${latest}/Inveigh-net7.0-linux-x64-trimmed-single-${version}.tar.gz" && \ 
    wget -O Inveigh.tar.gz "$download_link" && \   
    ouch decompress Inveigh.tar.gz --dir ~/Tools && \   
    rm Inveigh.tar.gz && \
    chmod 777 ~/Tools/Inveigh/inveigh

# Installs Waybackurls (Very simple installation, I'm putting this here since ik go has been working properly.)

RUN go install github.com/tomnomnom/waybackurls@latest

# Installs ffuf

RUN go install github.com/ffuf/ffuf/v2@latest

# Reconftw Installation (Won't be installed during the docker run process.)
# I recommend you to run Reconftw as it installs and configures a bunch of useful
# Web, OSINT, Enumeration (Nuclei, Subdomains, etc.)
# FYI nuclei-templates will be installed in the home directory due to a hardcoded
# line in Reconftw, I've submitted an issue and will fix it whenever possible.
# Update: Reconftw devs have fixed this issue!

RUN git clone https://github.com/six2dez/reconftw ~/Tools/reconftw

COPY Config/reconftw.cfg ${HOME}/Tools/reconftw/reconftw.cfg

# Installs updated Crackmapexec (God I should've known about this sooner.....)
# The original CME has been unmaintained/abandoned, and thus replaced with Netexec alongside it's new installations.
# Installation will thus be archived.

#RUN git clone https://github.com/Porchetta-Industries/CrackMapExec.git ~/Tools/CrackMapExec && \
#    pipx install ~/Tools/CrackMapExec

RUN pipx install git+https://github.com/Pennyw0rth/NetExec

# Installs enum4linux-ng (I recommend using CME for RID cycling.)

RUN git clone https://github.com/cddmp/enum4linux-ng.git ~/Tools/enum4linux-ng && \
    pipx install ~/Tools/enum4linux-ng

# Installs Pwncat-cs, which is a C2 tool,
# It does have auto-privesc functionality so beware if you're using this tool for OSCP.

RUN pipx install pwncat-cs

# Installs SharpCollection's compiled binaries (Certify, Rubeus etc.)

RUN git clone https://github.com/Flangvik/SharpCollection.git ~/Tools/SharpCollection

# Installs targetedKerberoast

RUN git clone https://github.com/ShutdownRepo/targetedKerberoast.git ~/Tools/targetedKerberoast && \
    pip3 install -r ~/Tools/targetedKerberoast/requirements.txt && \
    chmod 777 ~/Tools/targetedKerberoast/targetedKerberoast.py

# Installs NoSQLI Injector

RUN go install github.com/Charlie-belmer/nosqli@latest

# Installs AWS Cli

RUN curl --retry-all-errors --retry 5 "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    mv aws .aws

# Install Tools and Open Planned Ports
# FYI Impacket is installed twice as a fallback measure.

RUN apt-get update && apt-get install -y \
    python3 \
    iputils-ping \
    ncat \
    metasploit-framework \
    perl \
    feroxbuster \
    tcpdump \
    nmap \
    smbmap \
    john \
    socat \
    hydra \
    hashcat \
    gnupg \
    wpscan \
    nikto \
    dnsutils \
    evil-winrm \
    jq \
    libncurses5-dev \
    libncursesw5-dev \
    exploitdb \
    hashid \
    man-db \
    mitmproxy \
    crunch \
    tmux \
    ftp \
    webshells \
    wireshark \
    ttf-ancient-fonts \
    impacket-scripts \
    python3-impacket \
    certipy-ad \
    gpp-decrypt \
    peass \
    kpcli \
    putty-tools \
    smbclient \
    python3-ldap3 \
    python3-yaml \
    neo4j \
    bloodhound \
    && rm -rf /var/lib/apt/lists/*
        
# Does a final update of everything
# Includes SSH fix and any other future fixes.
    
RUN sudo apt-get update && apt-get upgrade -y && \
    sudo apt-get autoremove && \ 
    echo "MACs hmac-sha1" >> /etc/ssh/ssh_config
    
# Transfers Over All The Config Files.
# Add Chown Perms for Alt User

COPY Config/.* ${HOME}/
COPY Config/init.lua ${HOME}/.config/nvim/init.lua
COPY --chown=${USER_ALT}:${USER_ALT} Config/Vanguard_Worship_Files/* /home/${USER_ALT}/Vanguard_Worship_Alter/

# Moves and Activates init.lua (NeoVim) file.
# Turns out the require error is intended and it seems to be fine once PlugInstall runs.

RUN  mkdir -p "${HOME}/.local/share" && \
     mv nvim-linux64/* "${HOME}/.local/share/nvim" && \
     rm -r nvim-linux64 && \
     ~/.local/share/nvim/bin/nvim --headless +PlugInstall +qall 1>/dev/null 2>/dev/null 
    

# Sets Execute Perms on offering script.
    
RUN chmod 777 /home/$USER_ALT/Vanguard_Worship_Alter/Offering.sh

# I will be removing the installation of some tools as Reconftw does them for me.
# I have setup a custom configuration of Reconftw to do just that.
# However, I will be placing the old installations/configurations here just in case.
#
# Apt installations: httprobe,whois,ffuf,subfinder
#
#
# Installs DalFox for XSS.
#
#RUN go install github.com/hahwul/dalfox/v2@latest
#
# Installs Gospider for BugBounty Purposes
#
#RUN go install github.com/jaeles-project/gospider@latest
#
# Installs Nuclei for automated scanning.
#
#RUN go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
#
# Installs Arjun for parameter fuzzing.
#
#RUN pipx install arjun
# 
# Mimikatz has been removed cuz it's part of the SharpCollection repo. 
#
# Bloodhound + Neo4j has been re-added as I realized bloodhound python (or CME's bloodhound option) does not work with Bloodhound CE

# Signifies Ports to be Used. 
# Most are tool/service related or misc.
# UDP ones exist cuz of Responder/LLMNR attacks.

EXPOSE 21
EXPOSE 22
EXPOSE 25
EXPOSE 53
EXPOSE 53/udp
EXPOSE 80
EXPOSE 88
EXPOSE 110
EXPOSE 135
EXPOSE 137/udp
EXPOSE 138/udp
EXPOSE 139
EXPOSE 389
EXPOSE 389/udp
EXPOSE 443
EXPOSE 445
EXPOSE 546
EXPOSE 546/udp
EXPOSE 547
EXPOSE 547/udp
EXPOSE 587 
EXPOSE 636 
EXPOSE 1180
EXPOSE 1433
EXPOSE 1434/udp
EXPOSE 3141
EXPOSE 3128
EXPOSE 4443
EXPOSE 4444
EXPOSE 5353/udp
EXPOSE 5355/udp
EXPOSE 5985
EXPOSE 6501
EXPOSE 6666
EXPOSE 6969
EXPOSE 8000
EXPOSE 8081
EXPOSE 8080
EXPOSE 8585
EXPOSE 8888
EXPOSE 8889
EXPOSE 9090
EXPOSE 11601

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
