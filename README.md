## Minecraft &trade; Server Management Scripts
These scripts will allow you to host your own Minecraft &trade; (Java Edition) server in no time! These scripts were designed for a server hosted on a linux based operating system (OS).

Before you get started, you will need to install a few prerequisites...

#### Install "jq" and "screen" packages
Using your platform's package manager, install jq, screen and git.
```bash
# For Redhat:
$ sudo yum install jq -y
$ sudo yum install screen -y
$ sudo yum install git -y
```
```bash
# For Debian:
$ sudo apt install jq -y
$ sudo apt install screen -y
$ sudo apt install git -y
```
#### Install Java Development Kit (64-bit JDK)
Minecraft &trade; requires Java to run. By selecting a 64-bit Java, you can configure the server to use more than 1024M of memory.
```bash
# For Redhat:
$ sudo yum install openjdk-11-jre-headless -y
```
```bash
# For Debian:
$ sudo apt install openjdk-11-jre-headless -y
```

#### Staring your first Minecraft &trade; server
Now that all the prerequisites have been installed, it's time to start your first Minecraft &trade; server. Clone this repo to the location where you wish to run the server from and use the create script.
```bash
$ git clone git@github.com:McFaddenJC/minecraft-scripts.git
$ cd minecraft-scripts
$ ./create-server.sh <release/snapshot> <server_name> <port> <gamemode>
```
Sit back and watch your server download the type of server you specified and configure it to use the port and game mode you selected. This script runs your world inside of a "screen".

#### Screen commands to interact with server
This project uses the "screen" capability to allow interaction with your server as needed. Here are some common screen commands that you will want to become familiar with:
```bash
# List available screens to attach to
$ screen -list

# Attach to a listed screen. This allows you to send commands to the server.
$ screen -x <screen_name>

# Detach from current screen by holding control, pressing a, releasing both, and then pressing d (allows it to keep running)
$ CTRL-a + d
```

#### Setting up CRON to keep your server updated
The update-server.sh script will keep your Minecraft &trade; server up-to-date with either the latest release or the latest snapshot. Here are some commands to help you get started running this in CRON.
```bash
# Open cron in edit mode (this assumes you are using vim)
$ crontab -e

# Press "i" to enter insert mode and create the following entry:
*/5 * * * * /<full_path>/minecraft-scripts/update-server.sh <release/snapshot> <server_name> <gamemode> > /dev/null 2>&1

# Press "ESC" and then type ":wq" to save your changes
```
Now cron will check for a new version on the defined basis but will not do anything if the current version matches the latest available. You can use this script to switch between releases and snapshots, or between creative, survival, and adventure mode. If the script detects a newer version it will:
* Stop the server (with a countdown warning to any players who happen to be online)
* Back up your world
* Remove the old server .jar file
* Download the new server .jar file
* Update the server.properties file's "motd" and "gamemode"
* Start the server back up


#### Configuring Server Auto Loading
Now that you have your own Minecraft &trade; servers up and running, you want them to start when you start up your server. This is accomplished by creating a startup script for your server. For the purpose of this tutorial, I will call my script "minecraft" to keep things simple.

Using your editor of choice, create a file in /etc/init.d called "minecraft"

```bash
$ sudo vim /etc/init.d/minecraft
```
Add the following to your new file:
```bash
#!/bin/bash

echo "Starting all minecraft servers"
su - <your ssh username> -c "/<your install path>/minecraft-scripts/all-start.sh"
```
Now you need to assign your script to a runlevel. In this case, I have added the script to runlevel 5. To do this, simply create a symbolic link (symlink) like this:

```bash
$ cd /etc/rc5.d/
$ sudo ln -s ../init.d/minecraft S01minecraft
```
That's all! From this point onward, any time you have to restart your server, your worlds will start automatically upon boot.
