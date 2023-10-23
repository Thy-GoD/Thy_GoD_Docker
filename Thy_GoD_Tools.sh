#!/bin/bash

# Thigh Terminal Startup Script
# Created By Thy GoD, 
# using Chat GPT for initial code/debugging 
# and Nutek-Terminal/Nutek-Shell for Code Snippets/Inspiration.

# Function to stop container when exited. (fresh reset with data intact)
stop_container() {
    docker stop $CONTAINER_NAME > /dev/null 2>&1
}

# Set the container name
CONTAINER_NAME="Thigh_Terminal" # This value can be changed. 

# Set home path 
HOME_VAR="/root" # Change this if you made changes in the dockerfile.

# Sets Terminal Title (Can be Changed)
echo -ne "\033]0;$CONTAINER_NAME\007"

# Set the image name
IMAGE_NAME="thyimage/thy-terminal:latest" # This value can change depending on what you want to call your image. 

# Set the path to the Dockerfile
DOCKERFILE_PATH="." # This value can be changed for whatever reason. (Defaults to Repo Dir)

# Sets this script's directory.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SHARED_FOLDER_PATH="$SCRIPT_DIR/Shared_Folder"
CONFIG_FOLDER_PATH="$SCRIPT_DIR/Config"

# Sets the font directory, you can change it if it doesn't work.
font_dir="${HOME}/.local/share/fonts"

# Finds Host's IP Address
HOST_IP=$(hostname -I | awk '{print $1}') 

# Initializes Host Access to Display
# Check if the user is already in the access control list
if [[ ! $(xhost) =~ "LOCAL:" ]]; then
    # Add the user to the access control list
    xhost +local:$(id -nu)
fi

# Help Commands Page.

if [[ $1 = "-h"  ]] || [[ $1 = "--help" ]] || [[ $1 = "help" ]] || [[ $1 = "-help" ]]; then
  echo ""
  echo -e "                   Welcome to the help page, some of these commands must be run as root.\n"
  echo "                    I recommend running the first command as it's just more convenient."
  echo "        The 2nd command if you want to use the container without host networking, and the 3rd if you do."
  echo "-----------------------------------------------------------------------------------------------------------"
  echo ""
  echo "Usage: ./Thy_GoD_Tools.sh *insert command here*"
  echo -e "Without any commands, it will either setup the container, or spawn a terminal into it.\n"
  echo "Command: docker (Requires running as root.)"
  echo "This command automatically places your current user into the docker group, so that you won't"
  echo -e "need to run this script with sudo/as root each time you want to enter the container.\n"
  echo "Command: autoroute (Requires running as root.)"
  echo "This command sets up smcroute + enables ipv6 for docker, so that LLMNR and DHCPv6 can work."
  echo -e "It is recommended to read the command's comments or create an issue thread if you face any issues.\n"
  echo "Command: host (Has to be run BEFORE creating the container.)"
  echo "This command runs the docker container with --network=host. "
  echo "You would not need to run autoroute as the docker container would use the host's network instead."
  echo -e "This is recommended for actual pentests so that you won't need to bother configuring smcroute.\n"
  echo "However, do take note that ALL ports in the docker container will be exposed as it is,"
  echo -e "essentially using the host's networking stack. (Make sure not to leave open services or ports.)\n"
  echo ""
  echo "Created By Thigh GoD"
  exit 0
fi

# As I want this script to be run-able without root, 
# you will have to run this command as root in order to automatically enable Multicast traffic forwarding.
# This will install smcroute, configure it, then setup docker's daemon for ipv6.

if [[ $1 = "autoroute" ]] || [[ $1 = "--autoroute" ]] || [[ $1 = "-autoroute" ]]; then
	if [[ $EUID -eq 0 ]]; then
		if  ! which smcroute >/dev/null 2>&1 ;then
			apt update && apt install smcroute -y
			cp "$CONFIG_FOLDER_PATH/smcroute.conf" /etc/
			systemctl enable smcroute
			clear
			echo "Smcroute has been configured!"
			echo "If this didn't work, likely smcroute doesn't exist in ur sources list."
			echo "Now setting up ipv6 for docker."
			echo "--------------------------------"
			cp "$CONFIG_FOLDER_PATH/daemon.json" /etc/docker/
			service docker restart
			systemctl restart smcroute
			echo "ipv6 for docker has been configured!"
			echo "If this didn't work, it's likely due to the service command not existing."
			exit
		else
			echo "Smcroute already exists, either uninstall it and re-run the script, or manually move the smcroute configuration."
			echo "To do so, move /Config/smcroute.conf to /etc/smcroute.conf, I recommend using cp instead of mv."
			exit 0
		fi
	else
		echo "This command must be run as root!"
		exit 0
	fi 
fi

# To make life easier, I've also added a command to automatically add the user to the docker group.
# This way, you won't need to run docker with sudo each time. 
# However, do take note of the possible security concerns over this. 
# In most cases it would not matter, however it is not possible to run this script as root all the time.
# Which means that running it as a terminal/shortcut would not be possible, if you wish to go with the safer but less convenient route.

if [[ $1 = "docker" ]] || [[ $1 = "--docker" ]] || [[ $1 = "-docker" ]]; then
        if [[ $EUID -eq 0 ]]; then
		if ! which docker >/dev/null 2>&1 ; then
			echo "Docker has not been installed, attempting to install....."
			apt update && apt install docker.io -y
			echo "Installation succeeded, continuing with setup."
		fi

		if [[ $(id | grep "docker") ]];then
			echo "User has already been added to the docker group."
			exit 0
		else
			if ! grep -q "^docker:" /etc/group; then
				groupadd docker
			fi
			usermod -aG docker $USER
			newgrp docker
			echo "User successfully added to docker group, please re-login/reboot just in case."
			echo "Also, do check if you are indeed able to run docker without using root/sudo."
			exit
		fi
	else
		echo "This command must be run as root!"
		exit 0
	fi
fi

# Check if the container is already running.
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    clear
    # Sets Terminal Title (Can be Changed)
    echo -ne "\033]0;$CONTAINER_NAME\007"
    echo "Initiating Running Container....."
    echo ""
    # Start an Interactive shell
    docker exec -it -e HOST_IP=$HOST_IP $CONTAINER_NAME zsh

    
# Check if the container exists and is stopped.
elif [ "$(docker ps -a -f name=$CONTAINER_NAME | grep $CONTAINER_NAME | grep Exited)" ]; then
    clear
    # Sets Terminal Title (Can be Changed)
    echo -ne "\033]0;$CONTAINER_NAME\007"
    echo "Started Stopped Container....." 
    echo ""
    # Runs the Container
    docker start $CONTAINER_NAME 1>/dev/null
    docker exec -it -e HOST_IP=$HOST_IP $CONTAINER_NAME zsh
    
# Else, Build the Image using a Docker File.
else
    
    # Installs NerdFont Prior to Installation if it doesn't already exist.
    if ! [[ -f "${font_dir}/SymbolsNerdFont-Regular.ttf" ]]; then
	    # Gets Latest Version (Credits to Dewalt from TCM Security for this line of code.)
            latest=$(curl -IL -s https://github.com/ryanoasis/nerd-fonts/releases/latest | sed -n /location:/p | cut -d ' ' -f 2 | tr -d '\r\n')
            latest=$(echo "${latest/tag/download}")
            latest+="/NerdFontsSymbolsOnly.zip"
            wget -O NerdFontsSymbolsOnly.zip ${latest}

            # Checks if Font Folder already exists.
            if ! [[ -d "${font_dir}" ]]; then
		    mkdir "${font_dir}"
            fi

            mv NerdFontsSymbolsOnly.zip "${font_dir}"
            unzip "${font_dir}/NerdFontsSymbolsOnly.zip" -d "${font_dir}/"
            rm "${font_dir}/NerdFontsSymbolsOnly.zip"
            fc-cache -fv
    fi

    clear
    
    # Build the image
    docker build -t $IMAGE_NAME $DOCKERFILE_PATH
    
    # Run the container
    clear
    echo "Just a couple notes, please change your burpsuite settings (or any similar) to enable listening on all interfaces."
    echo "This is cuz you won't be able to use them properly as your container is refusing connections from the host."
    echo "--device command might break or not work, it's there to make ligolo-ng work."
    echo "Bloodhound has been deprecated and moved to being containerized, see README for more info. FYI it's on port 1234"
    echo "Lastly, there's a couple ways to use Inveigh (I removed responder and pretender as Inveigh does both but better.)"
    echo "1. You run this script normally and put the binary in Shared_Folder, then run it on host."
    echo "2. You run this script with sudo perms to initialize the smcroute setup. (Only once then you can enable the service whenever.)"
    echo "3. You run this script with the 'host' argument that makes it use the host's network (Not safe, but more convenient.)"
    echo "4. You setup and run the smcroute configuration by yourself manually, I have included the needed smcroute.conf in the Config folder."
    echo "If you are seeing this message while the container isn't creating, either my script is fucked, ur doing it wrong,"
    echo "or this OS/Distro isnt supported."
    echo ""

    if [[ $1 = "host" ]] || [[ $1 = "-host" ]] || [[ $1 = "--host" ]]; then
	    echo "This container has been created with Host Networking"
	    docker run --cap-add=NET_ADMIN -it -h Thigh-Terminal --device /dev/net/tun:/dev/net/tun -v $SHARED_FOLDER_PATH:$HOME_VAR/Shared_Folder -v \
	    /tmp/.X11-unix:/tmp/.X11-unix --shm-size=1g -e DISPLAY=$DISPLAY --name $CONTAINER_NAME $IMAGE_NAME zsh
    else    
	    docker run --cap-add=NET_ADMIN -it -h Thigh-Terminal -p 21:21 -p 22:22 -p 25:25 -p 53:53 -p 53:53/udp -p 80:80 -p 88:88 -p 110:110 -p 135:135 \
	    -p 137:137/udp -p 138:138/udp -p 139:139 -p 389:389 -p 389:389/udp -p 443:443 -p 445:445 -p 546:546 -p 546:546/udp -p 547:547 -p 547:547/udp \
	    -p 587:587 -p 636:636 -p 1180:1180 -p 1433:1433 -p 1434:1434/udp -p 3141:3141 -p 3128:3128 -p 4443:4443 -p 4444:4444 -p 5353:5353/udp -p 5355:5355/udp \
	    -p 5985:5985 \
	    -p 6501:6501 -p 6666:6666 -p 6969:6969 -p 8000:8000 -p 8081:8081 -p 8080:8080 -p 8585:8585 -p 8888:8888 -p 8889:8889 -p 9090:9090 \
	    -p 11601:11601 \
	    --device /dev/net/tun:/dev/net/tun --device /dev/snd:/dev/snd -v $SHARED_FOLDER_PATH:$HOME_VAR/Shared_Folder -v \
	    /tmp/.X11-unix:/tmp/.X11-unix --shm-size=1g -e DISPLAY=$DISPLAY --name $CONTAINER_NAME $IMAGE_NAME zsh
    fi

    # This part can be edited to have Variable values, to allow greater customization. 
    # Note that --cap-add=NET_ADMIN is used to give the docker container more perms, port:port is used to bind docker ports to host ports.
    # -v PWD (Current Working Directory) is used to create a shared folder, you can change this bit, but I doubt you have to.
    # I can add plans to allow ports to be manually configurable, but honestly you can just change them here to make them permament changes.
    # Instead of needing to specify them each time.
    # Well technically I can make them permanent but o well.
    # FYI you can add '--rm' to remove the container and all of it's contents once you exit it.
    # Update: It is recommended to run xhost +local:$(id -nu) to allow the docker container to use the host's display.
    # This is run automatically by default, tho.
    # Update2: Added an argument to run the container with host networking instead, to make LLMNR and DHCPv6 poisoning more convenient.
fi

# Binds the 'exit' command to the stop_container function
trap stop_container EXIT

# Made with thanks from Nutek-Terminal for the inspiration/code, Chat GPT for starting code/debugging and Google. 
