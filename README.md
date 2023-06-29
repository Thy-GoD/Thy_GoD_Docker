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

Container has not been tested with tmux, but Konsole's split view instead.

Update: Tested tmux and it should work fine, I will add it's installation to be by default.

## Note: 

I will occasionally make changes to the container, in order to optimize, add, edit, or fix bugs.

Please give the dockerfile and Tools.sh a read as there is alot of customization/notifications.

## TODO List:

I will plan on reorganizing everything (Creating files so that I won't have to echo everything manually).
<br>
Lastly i'll do more testing and hope shit doesn't break.

-Thigh GoD
