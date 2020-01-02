# Introduction

The following document includes information, instructions about how to install, configure volumio on raspberry and tricks 
needed to install your favourite web radios, ...

## Table of Contents

   * [Configuration of volumio post SD card created](#configuration-of-volumio-post-sd-card-created)
   * [Play a playlist](#play-a-playlist)
   * [Automate the restart of the Web radio using a Playlist](#automate-the-restart-of-the-web-radio-using-a-playlist)
   * [Issues](#issues)
      * [Wifi network](#wifi-network)

## Configuration of volumio post SD card created

- Static IP addresses used for the wireless network : `192.168.1.90` and `192.168.100` for the wired network
- DAC model: `Allo BOSS - Raspberry Pi "Master" DAC v1.2`
- Output: `Jack`
- To enable ssh, follow the instructions [here](https://volumio.github.io/docs/User_Manual/SSH.html) and access the server at this address
  `http://volumio.local/dev`
- By default, `vi` is not installed OOTB. To install it, follow these instructions:
  ```bash
  sudo apt-get update
  sudo apt-get install vim
  ```
- To use the list of your web or favourites radio, scp the following files: `radio-playlist/my-web-radio`, `radio-playlist/radio-favourites`
  ```bash
  sshpass -p "volumio" scp radio-playlist/my-web-radio volumio@192.168.1.100:/data/favourites/
  sshpass -p "volumio" scp radio-playlist/radio-favourites volumio@192.168.1.100:/data/favourites/
  ```
                  
## Play a playlist

- SSH to the volumio vm and create a playlist file `Classic21` under the folder `/data/playlist`
```bash
cd /data/playlist
touch Classic21
cat <<EOF > Classic21
[{"service":"webradio","uri":"https://radios.rtbf.be/classic21-128.mp3","title":"Classic21","albumart":"/albumart"}]
EOF
```
- To use it, restart volumio and next execute the following curl/http query to use the playlist of Classic21's [file](radio-playlist/Classic21) 
```bash
http volumio.local:3000/api/v1/commands/?cmd='playplaylist&name=Classic21'
 HTTP/1.1 200 OK
Access-Control-Allow-Headers: Content-Type, Authorization, Content-Length, X-Requested-With
Access-Control-Allow-Methods: GET,PUT,POST,DELETE,OPTIONS
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 56
Content-Type: application/json; charset=utf-8
Date: Wed, 01 Jan 2020 13:48:11 GMT
ETag: W/"38-oG+PiIBYVseelqjF9RMXvNTQ2Q0"
Vary: Accept-Encoding
X-Powered-By: Express

{
    "response": "playplaylist Success",
    "time": 1577886491442
}
[1]  + 28205 done       http volumio.local:3000/api/v1/commands/?cmd=playplaylist
```

## Automate the restart of the Web radio using a Playlist

- Install cron and check if it works
```bash
apt-get install cron
systemctl status cron
```

- Add a bash script file `/home/volumio/playlist.sh` to check if volumio web server has started in order to launch the playlist
```bash
#/bin/sh
 
volumio=localhost:3000/api/v1/commands
until $(curl --silent --output /dev/null --head --fail ${volumio}); do
   echo "We wait till volumio is up and running"
   sleep 10s
done

sleep 20s
echo "Volumio server is running, so we can launch our playlist"
curl localhost:3000/api/v1/commands/?cmd='playplaylist&name=Classic21' 
```
**Remark**: Change the name of the playlist

- Edit the cron config file`/edit/crontab` and add this line which is used at boot time.
```bash
@reboot volumio /home/volumio/start-playlist.sh >> /var/log/cron.log
```
- Example of `/edit/crontab` file updated
```bash
-rw-r--r-- 1 root root 913 Jan  1  2019 /etc/crontab
root@volumio:~# cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

MAILTO=""
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user	command
17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#*/2 *   * * *   volumio    echo "salut ....." >> /var/log/cron.log

## Reboot and use playlist defined / default
@reboot volumio /home/volumio/start-playlist.sh >> /var/log/cron.log
```

**NOTE**: Ticket created to track this problem : https://github.com/volumio/Volumio2/issues/1693

## Issues
 
### Wifi network

- Read the following [ticket](https://github.com/volumio/Volumio2/issues/926) and apply the bash script
```bash
mkdir /usr/local/bin/wifi-check 
cd /usr/local/bin/wifi-check 
touch wifi-check.sh 

cat <<EOF > wifi-check.sh 
#! /bin/sh 

ssid=$(/sbin/iwgetid --raw) 

if [ -z "$ssid" ] 
then 
    echo "Wifi is down, reconnecting..." 
    /sbin/ifconfig wlan0 down 
    sleep 5 
    systemctl restart wireless 
fi 

echo "wifi-check done" 
EOF

chmod +x wifi-check.sh 
 
sudo crontab -e 
    */5 * * * * /usr/local/bin/wifi-check/wifi-check.sh
```