# Instructions

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

```