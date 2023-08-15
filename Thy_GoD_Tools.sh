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

# Sets the font directory.
font_dir="${HOME}/.local/share/fonts"

# Finds Host's IP Address
HOST_IP=$(hostname -I | awk '{print $1}') 

# Initializes Host Access to Display
# Check if the user is already in the access control list
if [[ ! $(xhost) =~ "LOCAL:" ]]; then
    # Add the user to the access control list
    xhost +local:$(id -nu)
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
    echo "Just a couple notes, please change your neo4j and burpsuite settings (or any similar) to enable listening on all interfaces."
    echo "This is cuz you won't be able to use them properly as your container is refusing connections from the host."
    echo "--device command might break or not work, it's there to make ligolo-ng work."
    echo "Lastly, you'll need to move pretender to the Shared_Folder as only host is able to use them."
    echo "If you are seeing this message while the container isn't creating, either my script is fucked, ur doing it wrong, or this OS/Distro isnt supported."
    echo ""
    docker run --cap-add=NET_ADMIN -it -h Thigh-Terminal -p 137:137/udp -p 138:138/udp -p 5353:5353/udp -p 5355:5355/udp -p 6666:6666 -p 8888:8888 -p 8081:8081 -p 6969:6969 -p 8889:8889 -p 8080:8080 -p 9090:9090 -p 8585:8585 -p 443:443 -p 80:80 -p 445:445 -p 21:21 -p 22:22 -p 4443:4443 -p 6501:6501 -p 7687:7687 -p 7474:7474 -p 53:53 -p 88:88 -p 389:389 -p 636:636 -p 1180:1180 -p 5985:5985 -p 11601:11601 -p 8000:8000 --device /dev/net/tun:/dev/net/tun -v $SHARED_FOLDER_PATH:$HOME_VAR/Shared_Folder -v /tmp/.X11-unix:/tmp/.X11-unix --shm-size=1g -e DISPLAY=$DISPLAY --name $CONTAINER_NAME $IMAGE_NAME zsh
    
    # This part can be edited to have Variable values, to allow greater customization. 
    # Note that --cap-add=NET_ADMIN is used to give the docker container more perms, port:port is used to bind docker ports to host ports.
    # -v PWD (Current Working Directory) is used to create a shared folder, you can change this bit, but I doubt you have to.
    # I can add plans to allow ports to be manually configurable, but honestly you can just change them here to make them permament changes.
    # Instead of needing to specify them each time.
    # Well technically I can make them permanent but o well.
    # FYI you can add '--rm' to remove the container and all of it's contents once you exit it.
    # Update: It is recommended to run xhost +local:$(id -nu) to allow the docker container to use the host's display.
    # This is run automatically by default, tho.
fi

# Binds the 'exit' command to the stop_container function
trap stop_container EXIT

# Made with thanks from Nutek-Terminal for the inspiration/code, Chat GPT for starting code/debugging and Google. 
