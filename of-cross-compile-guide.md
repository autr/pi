
# OpenFrameworks 0.10.1 Cross-Compile Guide Armv6

Tested macOS Mojave with Debian 9 via Parallels Desktop, Raspberry Pi 3B+ with Raspbian Stretch Lite, OpenFrameworks 0.10.1

### Prerequisites

* Linux Debian 9 installation or vitual machine
* USB stick (can be smaller than SD card, but large enough for filesystem)

### From the Pi

1️⃣ Install Raspbian Stretch

* [Download Raspbian Stretch](https://www.raspberrypi.org/downloads/raspbian/)
* On Mac, use [ApplePi Baker](https://www.tweaking4all.com/software/macosx-software/macosx-apple-pi-baker/) works well
* On Windows, use [PiBakery](https://www.pibakery.org/download.html)]
* On Linux `sudo dd bs=1M if=/dev/sdX of=raspbian.img status=progress`

2️⃣ SSH in and update everything:

```
sudo apt update && sudo apt upgrade
sudo raspi-config

# >>> expand filesystem
# >>> update raspi-config
# >>> enable GPIO, camera etc 
```

3️⃣ Install all OF dependencies:

```
cd ~/

# Get OF armv6 from downloads page...

wget https://openframeworks.cc/versions/v0.10.1/of_v0.10.1_linuxarmv6l_release.tar.gz 
tar -xvzf of_v0.10.1_linuxarmv6l_release.tar.gz
cd of_v0.10.1_linuxarmv6l_release/scripts/linux/debian
sudo ./install_dependencies.sh && sudo ./install_codecs.sh
```

4️⃣ Install any additional addon dependencies (optional):

```
# ofxOMXPlayer dependencies:

cd ~/of_v0.10.1_linuxarmv6l_release/addons
git clone https://github.com/jvcleave/ofxOMXPlayer.git
cd ofxOMXPlayer 
sudo ./install_depends.sh
```

5️⃣ Attach USB stick and copy entire filesystem:

```

# Install rpi-clone to bin

git clone https://github.com/billw2/rpi-clone.git 
cd rpi-clone
sudo cp rpi-clone rpi-clone-setup /usr/local/sbin
cd ../
rm -rf rpi-clone

# Find out name of USB stick

df -h

# Clone it

sudo rpi-clone sdX

```

You now have a backup USB…


### From Linux

1️⃣ Attach the USB and mount it

```

# View disks

df -h

# Root the larger partition

mkdir /media/Data
sudo mount /dev/sdb2 /media/Data/

```

2️⃣ Create a non-destructive copy of the root 

```
cd ~
mkdir RPI_ROOT
cd RPI_ROOT

# Create symlinks

ln -s /media/Data/etc/ etc
ln -s /media/Data/lib/ lib
ln -s /media/Data/opt/ opt

# Copy entire /usr directory

cp -Rv /media/Data/usr/ usr

```

3️⃣ Update hardcoded links to relative links in `usr` folder (see [comment](https://gist.github.com/jvcleave/46386092bd17da55e37d5bbbd11fb592#gistcomment-2582476))

```
cd usr/lib/arm-linux-gnueabihf

rm libanl.so libBrokenLocale.so libcidn.so libcrypt.so libdbus-1.so libdl.so libexpat.so libglib-2.0.so liblzma.so libm.so libmnl.so libnsl.so libnss_compat.so libnss_dns.so libnss_files.so libnss_hesiod.so libnss_nisplus.so libnss_nis.so libpcre.so  libresolv.so librt.so libthread_db.so libusb-1.0.so libutil.so libuuid.so libz.so

ln -s ../../../lib/arm-linux-gnueabihf/libanl.so.1  libanl.so        
ln -s ../../../lib/arm-linux-gnueabihf/libBrokenLocale.so.1  libBrokenLocale.so      
ln -s ../../../lib/arm-linux-gnueabihf/libcidn.so.1  libcidn.so        
ln -s ../../../lib/arm-linux-gnueabihf/libcrypt.so.1  libcrypt.so       
ln -s ../../../lib/arm-linux-gnueabihf/libdbus-1.so.3.14.15 libdbus-1.so       
ln -s ../../../lib/arm-linux-gnueabihf/libdl.so.2  libdl.so        
ln -s ../../../lib/arm-linux-gnueabihf/libexpat.so.1.6.2  libexpat.so       
ln -s ../../../lib/arm-linux-gnueabihf/libglib-2.0.so.0  libglib-2.0.so       
ln -s ../../../lib/arm-linux-gnueabihf/liblzma.so.5.2.2  liblzma.so        
ln -s ../../../lib/arm-linux-gnueabihf/libm.so.6  libm.so        
ln -s ../../../lib/arm-linux-gnueabihf/libmnl.so.0.2.0  libmnl.so        
ln -s ../../../lib/arm-linux-gnueabihf/libnsl.so.1  libnsl.so        
ln -s ../../../lib/arm-linux-gnueabihf/libnss_compat.so.2  libnss_compat.so      
ln -s ../../../lib/arm-linux-gnueabihf/libnss_dns.so.2  libnss_dns.so       
ln -s ../../../lib/arm-linux-gnueabihf/libnss_files.so.2  libnss_files.so      
ln -s ../../../lib/arm-linux-gnueabihf/libnss_hesiod.so.2  libnss_hesiod.so      
ln -s ../../../lib/arm-linux-gnueabihf/libnss_nisplus.so.2  libnss_nisplus.so      
ln -s ../../../lib/arm-linux-gnueabihf/libnss_nis.so.2  libnss_nis.so       
ln -s ../../../lib/arm-linux-gnueabihf/libpcre.so.3  libpcre.so        
ln -s ../../../lib/arm-linux-gnueabihf/libresolv.so.2  libresolv.so       
ln -s ../../../lib/arm-linux-gnueabihf/librt.so.1  librt.so       
ln -s ../../../lib/arm-linux-gnueabihf/libthread_db.so.1  libthread_db.so      
ln -s ../../../lib/arm-linux-gnueabihf/libusb-1.0.so.0.1.0  libusb-1.0.so       
ln -s ../../../lib/arm-linux-gnueabihf/libutil.so.1  libutil.so        
ln -s ../../../lib/arm-linux-gnueabihf/libuuid.so.1.3.0  libuuid.so        
ln -s ../../../lib/arm-linux-gnueabihf/libz.so.1.2.8  libz.so

```

4️⃣ Clone OpenFrameworks from Github, using one of two options: 

```
A) my own fork (has additional scripts)

git clone -b cross-compile-pi --recursive git@github.com:autr/openFrameworks.git

B) the current patched-release

git clone -b patched-release --recursive git@github.com:openframeworks/openFrameworks.git

```

5️⃣ Install dependencies & toolchain

```
# Dependencies

sudo openFrameworks/scripts/linux/download_libs.sh
sudo openFrameworks/scripts/linux/debian/install_dependencies.sh
sudo openFrameworks/scripts/linux/debian/install_codecs.sh

# CI Toolchain

sudo openFrameworks/scripts/ci/linuxarmv6l/install.sh
```

6️⃣ Update bash profile with ENV variables taken from `install.sh` (taking care to update `RPI_ROOT`)

```
# Edit .profile

sudo nano ~/.profile

# Add these

export OF_ROOT=/home/username/openFrameworks
export GCC_PREFIX=arm-linux-gnueabihf
export GST_VERSION=1.0
export RPI_ROOT=/home/username/RPI_ROOT 
export TOOLCHAIN_ROOT=${OF_ROOT}/scripts/ci/$TARGET/rpi_toolchain
export PLATFORM_OS=Linux
export PLATFORM_ARCH=armv6l
export PKG_CONFIG_LIBDIR=${RPI_ROOT}/usr/lib/pkgconfig:${RPI_ROOT}/usr/lib/${GCC_PREFIX}/pkgconfig:${RPI_ROOT}/usr/share/pkgconfig
export CXX="ccache ${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-g++"
export CC="ccache ${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-gcc"
export AR=${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-ar
export LD=${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-ld

# Reload .profile

. ~/.profile

# Check its reloaded

echo $RPI_ROOT

```

7️⃣ Compile openFrameworks

```
sudo openFrameworks/scripts/linux/compileOF.sh
```

8️⃣ Grab examples from commonly used addons (optional)

```
cd $OF_ROOT/addons

# For video playback...

git clone https://github.com/jvcleave/ofxOMXPlayer.git
mkdir ../examples/ofxOMXPlayer
cp -R ofxOMXPlayer/example* ../examples/ofxOMXPlayer/

# For the GPIO...

git clone https://github.com/kashimAstro/ofxGPIO.git
mkdir ../examples/ofxGPIO
cp -R ofxGPIO/example* ../examples/ofxGPIO/

# For the CSI camera...

git clone https://github.com/jvcleave/ofxOMXCamera.git
mkdir ../examples/ofxOMXCamera
cp -R ofxOMXCamera/example* ../examples/ofxOMXCamera/

# For awesome projection mapping...

git clone https://github.com/kr15h/ofxPiMapper.git
mkdir ../examples/ofxPiMapper
cp -R ofxPiMapper/example* ../examples/ofxPiMapper/
```

9️⃣ Try compiling all of the examples

```
sudo chmod -R 777 $OF_ROOT
cd $OF_ROOT/scripts/linux/buildAllRPIExamples.sh
```

If using my fork, script will copy template Makefile for each, loop back around and try to clean and rebuild failing examples, and finayll copy each compiled app to an of-rpi-examples folder. You can then copy these examples in one go for testing:

```
scp $OF_ROOT/of-rpi-examples pi@raspberrypi.local:~/
```

🔟 Test an app from the Pi

```
ssh pi@raspberrypi.local
./of-rpi-examples/3d/3DPrimitivesExample
```

Done! 🤞
