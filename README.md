# Raspberry Pi - Useful Stuff

## Images

#### Managing Pi SD card images

**From Pi**:

Copies to a smaller attached USB or card

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

Copies entire size of disk size

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

**On Mac / Window**:

Copies entire disk + __setup first installation of Raspbian__

[PiBakery](https://www.pibakery.org/download.html) _headless installs w. WIFI, SSH, VNC_

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
# Weirdly only sudo works for apps / python scripts
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
  
## VNC

#### Remote Desktop login for Pi

When running headless without a HDMI connection to the Pi, change framebuffer width and height to something more usable:

```
sudo nano /boot/config.txt
```

**Show Pi in Mac Finder**:

```zsh
sudo apt-get install netatalk
```

**Install VNC to Pi**:

```zsh
sudo raspi-config
# Enable VNC in options
```

**On Mac**:

* Download [RealVNC](https://www.realvnc.com/en/connect/download/viewer/)
* Connect to raspberrypi.local 

## GPIO

#### Using Pi's GPIO pins

**Add user to GPIO usergroup**

Fixes permission denied errors when using GPIO

```zsh
sudo adduser pi gpio
```

![gpio](images/gpio.png)

**Model 3B**:

![gpio](images/gpio-3b.jpg)

## OpenFrameworks

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

**ultrasonic.py**

Test GPIO ultrasonic sensor

## Apps


# Summary

**Raspbian Stretch Lite with**:

* Cloned, installed, built: `of_v0.10.1_linuxarmv6l_release`
* Installed `tinyvncserver omxplayer openssh-server git`
* HFS+ for Mac USB: `hfsplus hfsutils hfsprogs`
* Install `python-dev pip hcsr04sensor`
* Desktop GUI via:
  * `sudo apt-get install --no-install-recommends xserver-xorg`
  * `sudo apt-get install --no-install-recommends xinit`
  * `sudo apt-get install raspberrypi-ui-mods`
  * `sudo apt-get install lightdm`
* Install Vivaldi Browser
* GPU RAM to 128m
* Install `usbmount` and set service `sudo nano /lib/systemd/system/systemd-udevd.service`
* Did `autoremove && clean` to reduce size

_Recommended Sandisk UHS-I SD Card_