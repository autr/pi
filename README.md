# Raspberry Pi - Useful Stuff

## Images

#### Manage SD card images

**On Mac / Windows**:

Backup card to an image or restore image to a card. Created images are size of SD card being copied from, so to copy to a smaller card, use [rpi-clone](https://github.com/billw2/rpi-clone).

* [ApplePi Baker](https://www.tweaking4all.com/software/macosx-software/macosx-apple-pi-baker/) - Mac
* [PiBakery](https://www.pibakery.org/download.html) - Windows



**On the Pi**:

Copies to any USB stick or SD card attached to the Pi - copies to a smaller SD card (so long as there is room);

[rpi-clone](https://github.com/billw2/rpi-clone)

```zsh
# View disks
df -h

# Installation
git clone https://github.com/billw2/rpi-clone.git 
cd rpi-clone

sudo cp rpi-clone rpi-clone-setup /usr/local/sbin
# Run
sudo rpi-clone sdX
```

**On Ubuntu**:

Copies entire disk size to image:

```zsh
df -h # List disks
sudo dd bs=1M if=/dev/sdX of=name-of-image.img status=progress
```

**Shrink on Ubuntu**:

[PiShrink](https://github.com/Drewsif/PiShrink)

```zsh
# Installation:
wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
chmod +x pishrink.sh
sudo mv pishrink.sh /usr/local/bin

# Run
sudo pishrink.sh [-s] imagefile.img [newimagefile.img]
```

## Spring Cleaning


**Update all**:

```zsh
# Update all
sudo apt-get update
sudo apt-get -y upgrade
sudo rpi-update

# Update raspi-config
sudo raspi-config # and select Update
```

**Clear up**:

```zsh
# Remove package
sudo apt-get purge -y wolfram-engine

# Cleanup retrived package files
sudo apt-get clean

# Remove extra packages installed
sudo apt-get autoremove 
```

**Analyse**:

```zsh
# Bootup speeds
systemd-analyze blame 

# List of packages by size
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n 
```

## Useful Commands

**Do something on startup**:

```zsh
# For terminal
sudo nano /etc/rc.local
# For GUI
sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
# @sudo /home/pi/myscript.sh etc...
# Use sudo for apps and python scripts
```

**Unpack a tar.gz**:

```zsh
tar -xvzf your-file.tar.gz
```

**Executable**:

```zsh
chmod +x ./pi/scripts/*

**See package version**:

```zsh
dpkg -l openssl
```

**Install certain package**:

```zsh
sudo apt-get install openssl=1.0.2
```

**See filesizes**

```zsh
# Install:
sudo apt-get install ncdu
# Usage:
ncdu
```
  
## VNC and SSH

#### Manage Pi Remotely

Methods for remotely working with the Pi with no keyboard, mouse or monitor attached.

**SSH**

```zsh
# On Pi
sudo apt-get install openssh-server
# On Client
ssh pi@raspberrypi.local #etc
```


**Mount Pi Filesystem on Mac**:

You can work with the Pi Filesystem without SFTP using `sshfs`

```zsh

# On Pi
sudo apt-get install netatalk

# On Mac
brew install sshfs
sshfs pi@raspberrypi.local:/home /Volumes/Pi
open /Volumes/Pi

```

**View Pi Desktop from Mac / Windows / Linux**:

* On the Pi, enable VNC via `sudo raspi-config` to begin installation
* On tje client computer, install [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)

**VNC Resolution**

* Without an HDMI connection to the Pi, the resolution will be too small to work with via VNC
* Setting resolution via the GUI will add hdmi preferences that break automatic SD / HDMI switching
* Better to set via framebuffer in `/boot/config.txt`;

```
sudo nano /boot/config.txt

# Set a usable resolution

framebuffer_width=1440 # 2 x PAL width, 720px
framebuffer_height=1152 # 2 x PAL height, 576px

# GUI resolution options

# hdmi_force_hotplug=1
# hdmi_group=2
# hdmi_mode=4
```

## GPIO

#### Using Pi's GPIO pins

**Add user to GPIO usergroup**

This will fix pin permission errors through OF / Processing;

```zsh
sudo adduser pi gpio
```

![gpio](images/gpio.png)

**Model 3B**:

![gpio](images/gpio-3b.jpg)


**3.3V Logic!**

* Pi uses 3.3v logic on its board, not 5v like Arduino 
* Connected components should use a voltage divider (two resistors).
* [RPi Circuits](https://elinux.org/RPi_GPIO_Interface_Circuits)

![gpio](images/voltage-divider.png)

![gpio](images/voltage-divider-diagram.png)


## Processing for Pi

* [Processing for Pi](https://pi.processing.org/download/)
* Bash install script not working on Stretch, so:

```zsh
wget https://github.com/processing/processing/releases/download/processing-0265-3.4/processing-3.4-linux-armv6hf.tgz
tar -xvzf processing-3.4-linux-armv6hf.tgz
./processing-3.4/install.sh
```

* Pi Videos via [GL Video](https://github.com/gohai/processing-glvideo)
* 720p H264 working fine, 1080p is blank...

## OpenFrameworks for Linux Arm6

#### Working with OF on Pi

Cross compiling w. ofNode

* [ofNode](https://github.com/ofnode/of)
* [Cross-compiling Guide](https://github.com/ofnode/of/wiki/Cross-compiling-for-Raspberry-Pi)
  * Can Strech instead of Jessie
  * `bs=1M` not `bs=1m`

**Mount in READ-ONLY**:

```zsh
# Make copy
sudo dd bs=1M if=/dev/sdb of=raspi-stretch+of+ofnode-cross-compiler.img status=progress

# View offset
fdisk -lu raspi-stretch+of+ofnode-cross-compiler.img

# Second row "Start" value 94208  * 512 = 48234496
mkdir /tmp/rpi
mkdir /tmp/rpi/root
sudo mount -o loop,offset=48234496,rw,sync raspi-stretch+of+ofnode-cross-compiler.img /tmp/rpi/root
```
```
# OpenSSL must be 1.0.2 not 1.1.0

```

## Scripts

**playseries.sh**

Plays and loops videos within a folder

Install omxplayer

```zsh
sudo apt install omxplayer
```

Move to bin 

```zsh
sudo mv playseries.sh /usr/local/bin
```

Usage

```zsh
playseries [hdmi/local/both/alsa] [0,90,180,270] /media/usb/videos
```

**ultrasonic_osc.py**

Sends incoming Ultrasonic sensor from pins 11 and 12 to OSC destination `/Ultrasonic` on port 7000

**ultrasonic_listener.py**

Double-check port 7000 messages are being received

**processing_videoplayer.pde**

* Processing sketch to playback two video with an ultrasonic sensor
* Listens to port 7000 for `/Ultrasonic`
* Videos must be available in `~/Videos` or `/media/USB`

**update-upgrade.sh**

Apt-get upgrade install everything

## Apps


# Summary

**Raspbian Stretch Lite with**:

* Cloned, installed, built: `of_v0.10.1_linuxarmv6l_release`
* Installed `tinyvncserver omxplayer openssh-server git`
* HFS+ for Mac USB: `hfsplus hfsutils hfsprogs`
* Desktop GUI via:
  * `sudo apt-get install --no-install-recommends xserver-xorg`
  * `sudo apt-get install --no-install-recommends xinit`
  * `sudo apt-get install raspberrypi-ui-mods`
  * `sudo apt-get install lightdm`
* Install Vivaldi Browser
* GPU RAM to 128MB
* Install `usbmount` and set service `sudo nano /lib/systemd/system/systemd-udevd.service`
* Did `autoremove && clean` to reduce size
* Install python dependencies w. sudo (for gui autostart) `sudo pip pyosc`
* Install Processing w. GL Video & oscP5

_Recommended Sandisk UHS-I SD Card_