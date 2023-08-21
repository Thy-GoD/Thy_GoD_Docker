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

With Bloodhound's new updated push to using a Dockerized system instead, I've opted to pre-configure <br>
a docker-compose.yml file from their directory, to work in conjunction with this container.

Therefore, all you have to do is just run `docker-compose up` (`docker-compose down -v` to remove the containers.)<br>
in the new /Bloodhound directory.

Sharphound will still be available within the container itself.

This is subject to change as Bloodhound Community Edition is still being developed and it's new.

## Note: 

I will occasionally make changes to the container, in order to optimize, add, edit, or fix bugs.

Please give the dockerfile and Tools.sh a read as there is alot of customization/notifications.

## TODO List:

Add more features and constant bug fixes/updates to functionality. <br>
Add images and screenshots to make people actually want to use this lmao. <br>
Somehow find a way to magically make IPV6 DNS Takeover Attacks work. <br>

**Update on IPv6**:

Alright, I've tried to setup ipv6 on my docker container for ages and it's just never working.
If any of you reading this bother to help me, it's be wonderful.
What I've discovered is that dhcpv6 does not work at all, and pretender doesn't work while <br>
inside a docker container for god knows what reason.

**Update 2 on IPv6**:

Good news! Turns out I wasn't crazy and the main problem was that docker by nature does not forward<br>
multicast traffic, what does this mean? LLMNR and DHCPv6 rely on multicast, hence they don't work.
My solution was found when I stumbled upon a github issue thread on moby (docker networking)<br>
that explained a way to use smcroute to forward multicast traffic to the docker0 interface.

Lo and Behold! IT WORKS! Well, problem is that you'd have to run the commands as root.
Now due to security concerns, I'd recommend checking the Tools script out first, but if you trust me,<br>
run the tools command with a `autoroute` argument, like `sudo bash Tools.sh autoroute`.

The name of my tools script is longer, but you get what I mean.

FYI, you also have to change the spoofer ip(ipv6) to your host's so that it gets forwarded to the container.

Nevermind abt the bloodhound thing, I managed to get it to work within docker itself, poggers. <br>
Nevermind again, it doesn't work and completely broke, I'll be using the updated Bloodhound-Docker. <br>
Which I've configured such that all you need to do is go to the /Bloodhound directory and run docker-compose up. <br>

My endgame is to have a docker container that is so useful to the point where I could run it on any linux distro<br>
while maintaining all my configurations and tools for pentesting.

-Thigh GoD
