# Raspberry Pi - Useful Stuff

## Images

#### Managing Pi SD card images

**From Pi**:

Copies to a smaller attached USB or card

[rpishrink](https://github.com/billw2/rpi-clone)

```zsh
# View disks
df -h

# Installation
git clone https://github.com/billw2/rpi-clone.git 
cd rpi-clone

sudo cp rpi-clone rpi-clone-setup /usr/local/sbin
# Run
rpi-clone
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
sudo apt-get update
sudo apt-get -y upgrade
sudo rpi-update
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
sudo nano /etc/rc.local
```

**Unpack a tar.gz**:

```zsh
tar -xvzf your-file.tar.gz
```
  
## VNC

#### Controlling Pi via VNC Server

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

![gpio](images/gpio.png)

## OpenFrameworks

#### Working with OF on Pi

Cross compiling w. ofNode

* [ofNode](https://github.com/ofnode/of)
* [Cross-compiling Guide](https://github.com/ofnode/of/wiki/Cross-compiling-for-Raspberry-Pi)
  * Can Strech instead of Jessie
  * `bs=1M` not `bs=1m`



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
* Desktop GUI via:
  * `sudo apt-get install --no-install-recommends xserver-xorg`
  * `sudo apt-get install --no-install-recommends xinit`
  * `sudo apt-get install raspberrypi-ui-mods`
  * `sudo apt-get install lightdm`
* Did `autoremove && clean` to reduce size