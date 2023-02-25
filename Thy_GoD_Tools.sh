#!/bin/bash

# Thigh Terminal Startup Script
# Created By Thy GoD, 
# using Chat GPT for initial code/debugging 
# and Nutek-Terminal/Nutek-Shell for Code Snippets/Inspiration.


# Set the container name
CONTAINER_NAME="Thigh_Terminal" # This value can also be changed. 

# Sets Terminal Title (Can be Changed)
echo -ne "\033]0;$CONTAINER_NAME\007"

# Set the image name
IMAGE_NAME="THY_IMAGE:Latest" # This value can change depending on what you want to call your image. 

# Set the path to the Dockerfile
DOCKERFILE_PATH="/home/kali/HTB_Stuff/Thy_GoD_Docker/" # This value can be changed for personal use.

# Check if the container is already running.
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    clear
    # Sets Terminal Title (Can be Changed)
    echo -ne "\033]0;$CONTAINER_NAME\007"
    echo "Initiating Running Container....."
    echo ""
    # Start an Interactive shell
    docker exec -it $CONTAINER_NAME env TERM=xterm-256color /bin/zsh
    
# Check if the container exists and is stopped.
elif [ "$(docker ps -a -f name=$CONTAINER_NAME | grep $CONTAINER_NAME | grep Exited)" ]; then
    docker start $CONTAINER_NAME
    clear
    # Sets Terminal Title (Can be Changed)
    echo -ne "\033]0;$CONTAINER_NAME\007"
    echo "Started Stopped Container....." 
    echo ""
    # Start an Interactive shell
    docker exec -it $CONTAINER_NAME env TERM=xterm-256color /bin/zsh
    
# Else, Build the Image using a Docker File.
else
    # Build the image
    docker build -t $IMAGE_NAME $DOCKERFILE_PATH
    
    # Run the container
    clear
    docker run --cap-add=NET_ADMIN -it -h Thigh-Terminal -p 8888:8888 -p 6969:6969 -p 8889:8889 -p 8080:8080 -p 9090:9090 -p 8585:8585 -v /home/kali/HTB_Stuff/Thy_GoD_Docker/Shared_Folder:/root/Shared_Folder --name $CONTAINER_NAME $IMAGE_NAME 
    
    # This part can be edited to have Variable values, to allow greater customization. 
    # Note that --cap-add=NET_ADMIN is used to give the docker container more perms, port:port is used to bind docker ports to host ports.
    # -v Local_File_Path/Docker_File_Path is used to create a shared folder, you only need to change the Thy_GoD_Docker bit. 
    # I can add plans to allow ports to be manually configurable, but honestly you can just change them here to make them permament changes.
    # Instead of needing to specify them each time.
fi

# Made with thanks from Nutek-Terminal for the inspiration/code, Chat GPT for starting code/debugging and Google. 
