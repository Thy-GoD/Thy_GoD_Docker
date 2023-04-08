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
CONTAINER_NAME="Thigh_Terminal2" # This value can be changed. 

# Sets Terminal Title (Can be Changed)
echo -ne "\033]0;$CONTAINER_NAME\007"

# Set the image name
IMAGE_NAME="thyimage/thy-terminal:testing" # This value can change depending on what you want to call your image. 

# Set the path to the Dockerfile
DOCKERFILE_PATH="." # This value can be changed for whatever reason. (Defaults to Repo Dir)

# Sets This Script's Directory.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SHARED_FOLDER_PATH="$SCRIPT_DIR/Shared_Folder"

# Check if the container is already running.
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    clear
    # Sets Terminal Title (Can be Changed)
    echo -ne "\033]0;$CONTAINER_NAME\007"
    echo "Initiating Running Container....."
    echo ""
    # Start an Interactive shell
    docker exec -it $CONTAINER_NAME zsh

    
# Check if the container exists and is stopped.
elif [ "$(docker ps -a -f name=$CONTAINER_NAME | grep $CONTAINER_NAME | grep Exited)" ]; then
    docker start $CONTAINER_NAME
    clear
    # Sets Terminal Title (Can be Changed)
    echo -ne "\033]0;$CONTAINER_NAME\007"
    echo "Started Stopped Container....." 
    echo ""
    # Start an Interactive shell
    docker exec -it $CONTAINER_NAME zsh
    
# Else, Build the Image using a Docker File.
else
    # Build the image
    docker build -t $IMAGE_NAME $DOCKERFILE_PATH
    
    # Run the container
    clear
    docker run --cap-add=NET_ADMIN -it -h Thigh-Terminal -p 8888:8888 -p 8081:8081 -p 6969:6969 -p 8889:8889 -p 8080:8080 -p 9090:9090 -p 8585:8585 -p 443:443 -p 80:80 -p 445:445 -p 21:21 -p 22:22 -v $SHARED_FOLDER_PATH:$HOME/Shared_Folder --name $CONTAINER_NAME $IMAGE_NAME zsh
    
    # This part can be edited to have Variable values, to allow greater customization. 
    # Note that --cap-add=NET_ADMIN is used to give the docker container more perms, port:port is used to bind docker ports to host ports.
    # -v PWD (Current Working Directory) is used to create a shared folder, you can change this bit, but I doubt you have to.
    # I can add plans to allow ports to be manually configurable, but honestly you can just change them here to make them permament changes.
    # Instead of needing to specify them each time.
    # Well technically I can make them permanent but o well.
    # FYI you can add '--rm' to remove the container and all of it's contents once you exit it.
fi

# Binds the 'exit' command to the stop_container function
trap stop_container EXIT

# Made with thanks from Nutek-Terminal for the inspiration/code, Chat GPT for starting code/debugging and Google. 
