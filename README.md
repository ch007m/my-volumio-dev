# Instructions to creete Volumio's vm

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
- 

```bash
Generate private/public key and import it under github
cd ~/.ssh && ssh-keygen

git clone git@github.com:ch007m/volumio-plugins.git


```

