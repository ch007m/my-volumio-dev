#!/usr/bin/env bash

CPU=2
RAM=4000
DISK=25000
VIRTUAL_BOX_NAME="volumio" # VM Name
VDI_NAME=volumio-2.513-2018-12-07-x86
HOST_PATH="$HOME/Temp"
OSTYPE="Debian_64";
CPUCAP=100;
PAE="on";
VRAM=8;
USB="off";

if (($# == 0)); then
        echo "Usage : ./create-vm.sh -i /PATH/TO/IMAGE/DIR -c 4 -m 6000 -d 25000"
        echo "i - /path/to/image/dir - mandatory"
        echo "c - cpu option - default to 2"
        echo "m - memory (ram) option - default to 4000"
        echo "d - hard disk size (option) - default to 20000"
        echo "n - Name of the VirtualBox VM to be created - default to Centos-7"
        echo "h - hostpath of the shared volume between vm and host"
        exit 2
fi

while getopts ":i:c:m:d:n:h:" option; do

  case ${option} in

    i  ) IMAGE_DIR=${OPTARG};;
    c  ) CPU=${OPTARG:=${CPU}};;
    m  ) RAM=${OPTARG:=${RAM}};;
    d  ) DISK=${OPTARG:=${DISK}};;
    n  ) VIRTUAL_BOX_NAME=${OPTARG:=${VIRTUAL_BOX_NAME}};;
    h  ) HOST_PATH=${OPTARG:=${HOST_PATH}};;

    \? )
         echo "Invalid option: $OPTARG" 1>&2
         ;;
    :  )
         echo "Invalid option: $OPTARG requires an argument" 1>&2
         ;;
  esac
done

readonly IP_ADDRESS=192.168.66.50

echo "######### Poweroff machine if it runs"
vboxmanage controlvm $VIRTUAL_BOX_NAME poweroff
echo "######### .............. Done"

echo "######### unregister vm "$VIRTUAL_BOX_NAME" and delete it"
vboxmanage unregistervm $VIRTUAL_BOX_NAME --delete || echo "No VM by name ${VIRTUAL_BOX_NAME}"

echo "######### Copy disk.vdi created"
cp ${IMAGE_DIR}/centos7.vdi ${IMAGE_DIR}/disk.vdi

####################################################################
echo "######### Create vboxnet0 network and set dhcp server : 192.168.99.0/24"
vboxmanage hostonlyif remove vboxnet1
vboxmanage hostonlyif create
vboxmanage hostonlyif ipconfig vboxnet1 --ip 192.168.66.1 --netmask 255.255.255.0
vboxmanage dhcpserver remove --ifname vboxnet1
vboxmanage dhcpserver add --ifname vboxnet1 --ip 192.168.66.20 --netmask 255.255.255.0 --lowerip ${IP_ADDRESS} --upperip ${IP_ADDRESS}
vboxmanage dhcpserver modify --ifname vboxnet1 --enable

##########################################
echo "######### Create VM"
vboxmanage createvm --name ${VIRTUAL_BOX_NAME} --ostype "$OSTYPE" --register --basefolder=$HOME/VirtualBox\ VMs

echo "######### RAM       : ${RAM}"
echo "######### CPU       : ${CPU}"
echo "######### DISK SIZE : ${DISK}"


# VirtualBox Network
echo "######### Define NIC adapters; NAT and vboxnet1"
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} \
        --nic1 hostonly --hostonlyadapter1 vboxnet1 \
        --nic2 nat

# VM Config
echo "######### Customize vm; ram, cpu, ...."
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --memory "$RAM";
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --boot1 dvd --boot2 dvd --boot3 disk --boot4 none;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --chipset piix3;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --ioapic on;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --mouse ps2;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --cpus "$CPU" --cpuexecutioncap "$CPUCAP" --pae "$PAE";
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --hwvirtex off --nestedpaging off;

vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --vram "$VRAM";
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --monitorcount 1;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --accelerate2dvideo off --accelerate3d off;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --audio none;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --hpet on;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --x2apic off;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --rtcuseutc on;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --nestedpaging on;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --hwvirtex on;

vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --clipboard bidirectional;
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --usb "$USB";
vboxmanage modifyvm ${VIRTUAL_BOX_NAME} --vrde on;

echo "######### Resize VDI disk to 15GB"
vboxmanage modifyhd ${IMAGE_DIR}/${VDI_NAME}.vdi --resize ${DISK}

echo "######### Create IDE Controller, attach vdi disk"
vboxmanage storagectl ${VIRTUAL_BOX_NAME} --name "IDE Controller" --add ide --hostiocache on
#vboxmanage storageattach ${VIRTUAL_BOX_NAME} --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ${IMAGE_DIR}/vbox-config.iso
vboxmanage storageattach ${VIRTUAL_BOX_NAME} --storagectl "IDE Controller" --port 1 --device 0 --type hdd --medium ${IMAGE_DIR}/${VDI_NAME}.vdi

echo "######### Mount shared volume named shared between VM and host at this path "$HOST_PATH" "
vboxmanage sharedfolder add ${VIRTUAL_BOX_NAME} --name shared --hostpath ${HOST_PATH} --automount

echo "########## Add guest OS DNS"
VBoxManage modifyvm ${VIRTUAL_BOX_NAME} --natdnshostresolver1 on


echo "######### start vm and configure SSH Port forward"
vboxmanage startvm ${VIRTUAL_BOX_NAME} --type headless
vboxmanage controlvm ${VIRTUAL_BOX_NAME} natpf2 ssh,tcp,127.0.0.1,5222,,22