echo ""
echo "Updating/Upgrading Raspbian"
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y install rpi-update
rpi-update
echo "Updating/Upgrading completed"
echo ""