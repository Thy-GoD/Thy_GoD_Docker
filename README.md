# Thigh_Terminal / Thy_GoD_Docker

Is a Personal Docker Image  with Pentest tools and zsh plugins, inspired by Nutek-Terminal and runs on a base Kali Image.

There's also **auto-complete** and **auto-syntax-highlighting** on zsh, with a "cls" `clear && ls -a` alias.

Feel free to use this to make your own docker projects or whatever. 

(report bugs)

## How to use:

I've made it quite easy, simply run the tools.sh file, **(as root if any conflicts occur somehow.)**.

This obviously requires docker installed.

This will start to build the docker image, once it's done it'll put you inside the container.

You can make this container as a *terminal* by creating a shortcut that runs the tools.sh file.

tools.sh automatically starts the container, enters a running container, and stops the docker container when the "exit" command is used.

It is possible to use a terminal's split-view feature to split the docker terminal window, but honestly it's best to just use tmux.

I have added a custom tmux configuration that uses Ctrl + A as the entry command.

FYI, run `xhost +local:$(id -nu)` to allow your container to use the host's display.

Note that this is automatically done in the tools script, but I have not tested if it works all the time.

## Note: 

I will occasionally make changes to the container, in order to optimize, add, edit, or fix bugs.

Please give the dockerfile and Tools.sh a read as there is alot of customization/notifications.

## TODO List:

Add more features and constant bug fixes/updates to functionality.
My endgame is to have a docker container that is so useful to the point where I could run it on any linux distro<br>
while maintaining all my configurations and tools for pentesting.

-Thigh GoD
