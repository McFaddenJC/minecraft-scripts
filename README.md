## Minecraft Server Management Scripts
These scripts will allow you to host your own Minecraft (Java Edition) server in no time! These scripts were designed for a server hosted on a linux based operating system (OS).

Before you get started, you will need to install a few prerequisites...

#### Install "jq" and "screen" packages
Using your platform's package manager, install JQ and screen.
```bash
# For Redhat:
$ sudo yum install jq -y
$ sudo yum install screen -y
```
```bash
# For Debian:
$ sudo apt install jq -y
$ sudo apt install screen -y
```
#### Install Java Development Kit (64-bit JDK)
Minecraft requires Java to run. By selecting a 64-bit Java, you can configure how much memory the server will be allotted.
