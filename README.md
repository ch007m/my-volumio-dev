# Usefull commands

## Play a playlist

- Restart volumio using the Playlist of Classic21's [file](radio-playlist/PL_Classic21.json) 
```bash
http volumio.local:3000/api/v1/commands/?cmd=playplaylist&name=PL_Classic21
HTTP/1.1 200 OK
```

## Automate to restart the Web radio using its Playlist

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
curl localhost:3000/api/v1/commands/?cmd='playplaylist&name=PL_Classic21'
volumio@volumio:~$ 
```
**Remark**: Change the name of the playlist

- Edit the cron config file`/edit/crontab` and add this line which is used at boot time.
```bash
@reboot volumio /home/volumio/start-playlist.sh >> /var/log/cron.log
```

# Instructions to create Volumio's vm

- Download PC(x86/x64) image from [volumio](http://updates.volumio.org/x86/volumio/2.513/volumio-2.513-2018-12-07-x86.img.zip) web site and unzip it
```bash
unzip volumio-2.513-2018-12-07-x86.img.zip
```
- Convert the img to a Virtualbox VDI format
```bash
export image_file=volumio-2.513-2018-12-07-x86
VBoxManage convertfromraw --format VDI ${image_file}.img ${image_file}.vdi
```
- Next, mount the VDI file and create a VM
```bash
 ./create-vm.sh -i /path/to/vdi_folder
```

# Create a new Volumio plugin project

- ssh to the volumio's vm under the home dir
```bash
ssh volumio@192.168.66.50
cd ~/
```
- Git clone your forked volumio plugins project locally

**REmark** : Generate a private/public key within the VM and import the public key on github
```bash
cd ~/.ssh && ssh-keygen
...
git clone git@github.com:ch007m/volumio-plugins.git
```

- As mentioned, please run again the command as the project has been git cloned under the folder
  `/home/volumio/volumio-plugins` and pass to create the deezer project the following paraneters
  
 Plugin Category: `music_service`
 Name for your plugin: `deezer`
 Please insert your name: `Charles Moulliard`
 Brief description of your plugin (100 chars): `Deezer volumio plugin`
 
```bash
volumio plugin init
Welcome to the Volumio Plugin Creator!
You have to decide which category your plugin belongs to, then you have to select a name for it, leave us the rest ;)
Warning: make meaningful choices, you cannot change them later!

Creating a new plugin
? Please select the Plugin Category music_service
? Please insert a name for your plugin deezer
NAME: deezer CATEGORY: music_service
Copying sample files
? Please insert your name Charles Moulliard
? Insert a brief description of your plugin (100 chars) Deezer volumio plugin
Installing dependencies locally
npm notice created a lockfile as package-lock.json. You should commit this file.
npm WARN deezer@1.0.0 No repository field.

Congratulation, your plugin has been succesfully created!
You can find it in: /home/volumio/volumio-plugins/plugins/music_service/deezer
```

- The new plugin created is available here `/home/volumio/volumio-plugins/plugins/music_service/deezer`

```bash
Generate private/public key and import it under github
sh-keygen -t rsa -b 4096 -C "ch007m@gmail.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/volumio/.ssh/id_rsa):
Created directory '/home/volumio/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/volumio/.ssh/id_rsa.
Your public key has been saved in /home/volumio/.ssh/id_rsa.pub.
The key fingerprint is:
98:55:9c:53:9e:8f:a9:9f:db:0b:80:6e:12:64:58:79 ch007m@gmail.com
The key's randomart image is:
+---[RSA 4096]----+
|      .. ..o.    |
|     o. E.+. .   |
|    . o..  .o    |
|     o + .   +   |
|      + S . o .  |
|       o   o     |
|      . o . .    |
|       o   . +   |
|            +.o. |
+-----------------+

git clone git@github.com:ch007m/volumio-plugins.git
cd volumio-plugins

Welcome to the Volumio Plugin Creator!
You have to decide which category your plugin belongs to, then you have to select a name for it, leave us the rest ;)
Warning: make meaningful choices, you cannot change them later!

Creating a new plugin
? Please select the Plugin Category music_service
? Please insert a name for your plugin deezer
NAME: deezer CATEGORY: music_service
Copying sample files
? Please insert your name Charles Moulliard
? Insert a brief description of your plugin (100 chars) Deezer Volumio Plugin
Installing dependencies locally
npm notice created a lockfile as package-lock.json. You should commit this file.
npm WARN deezer@1.0.0 No repository field.


Congratulation, your plugin has been succesfully created!
You can find it in: /home/volumio/volumio-plugins/plugins/music_service/deezer

cd /home/volumio/volumio-plugins/plugins/music_service/deezer
git add ./ & git commit -m "Add new plugin" -a

git config --global user.email "ch007m@gmail.com"
git config --global user.name "Charles Moulliard"
git config --global push.default simple

push

volumio plugin refresh
ls -la /data/plugins/music_service/deezer/

volumio plugin install
This command will install the plugin on your device

Compressing the plugin
No modules found, running "npm install"
npm notice created a lockfile as package-lock.json. You should commit this file.
npm WARN deezer@1.0.0 No repository field.

Plugin succesfully compressed
Progress: 10
Status :Downloading plugin
Progress: 30
Status :Creating folder on disk
Progress: 40
Status :Unpacking plugin
Progress: 50
Status :Checking for duplicate plugin
Progress: 60
Status :Copying Plugin into location
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 70
Status :Installing dependencies
Progress: 90
Status :Adding plugin to registry
Progress: 100
Status :Plugin Successfully Installed
Done!
volumio@volumio:~/volumio-plugins/plugins/music_service/deezer$ ls -la /data/plugins/music_service/deezer/
total 56
drwxr-xr-x  4 volumio volumio 4096 Dec 23 19:40 .
drwxr-xr-x  3 volumio volumio 4096 Dec 23 19:40 ..
-rw-r--r--  1 volumio volumio   87 Dec 23 19:28 UIConfig.json
-rw-r--r--  1 volumio volumio    6 Dec 23 19:28 config.json
drwxr-xr-x  2 volumio volumio 4096 Dec 23 19:40 i18n
-rw-r--r--  1 volumio volumio 5770 Dec 23 19:29 index.js
-rw-r--r--  1 volumio volumio  376 Dec 23 19:29 install.sh
drwxr-xr-x 24 volumio volumio 4096 Dec 23 19:40 node_modules
-rw-r--r--  1 volumio volumio 5513 Dec 23 19:40 package-lock.json
-rw-r--r--  1 volumio volumio  428 Dec 23 19:29 package.json
-rw-r--r--  1 volumio volumio    3 Dec 23 19:28 requiredConf.json
-rw-r--r--  1 volumio volumio   99 Dec 23 19:28 uninstall.sh

```

