let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`
res=`tvservice -s | grep 'state ' | cut -d, -f2`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo "$(tput setaf 2)
`date +"%A, %e %B %Y, %X %Z"`
`uname -srmo`$(tput setaf 1)
`cat ascii.txt`
Uptime.............: ${UPTIME}
Memory.............: `cat /proc/meminfo | grep MemFree | awk {'print $2'}`kB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'print $2'}`kB (Total)
Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
Running Processes..: `ps ax | wc -l | tr -d " "`
CPU Temperature....: `/opt/vc/bin/vcgencmd measure_temp | cut -c 6-9 | awk '{ print $1 "°C" }'`
Free Disk Space....: `df -Ph | grep -E '^/dev/root' | awk '{ print $4 " of " $2 }'`
Resolution.........: ${res}
Hostname...........: `cat /etc/hostname`
Eth0 Address.......: `/sbin/ifconfig eth0 | grep 'inet ' | cut -d 'n' -f2 | awk '{print $2}'`
Wlan0 Address......: `/sbin/ifconfig wlan0 | grep 'inet ' | cut -d 'n' -f2 | awk '{print $2}'`
IP Addresses.......: `wget -q -O - http://icanhazip.com/ | tail`
Weather............: `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=EUR|PL|PL007|WARSZAWA|" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
$(tput sgr0)"