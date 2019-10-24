#!/bin/bash

echo "Which distribution do you want to install?"
echo "Write 1 for Ubuntu 18.04.3 LTS"
echo "Write 2 for Manjaro XFCE 18.1.1"
echo "Write 3 for Raspbian Version:September 2019"
echo "Write 4 for Flash windows Iso"
read response
diskutil list physical
echo "Write the disk on which the iso should be flashed ex :disk3 "
read diskfl

 LaunchFlash () {
        diskutil eraseDisk FAT32 $1 $diskfl
        diskutil unmountDisk /dev/$diskfl
        #if you want to see progress bar install pv with homebrews https://brew.sh/ comment l18 and uncomment l17
        #pv $1.iso | dd of=/dev/$diskfl
        sudo dd if=$1.iso of=/dev/$diskfl bs=1m
        diskutil eject /dev/$diskfl
        rm -i $1.iso 
        echo "Finish"
}

if [ $response  -eq 1 ]
    then
        curl http://releases.ubuntu.com/18.04.3/ubuntu-18.04.3-desktop-amd64.iso?_ga=2.67788756.45556580.1571741444-940794574.1571741444 > UBUNTU.iso
        LaunchFlash UBUNTU
elif [ $response  -eq 2 ]
    then
        curl https://dotsrc.dl.osdn.net/osdn/storage/g/m/ma/manjaro/xfce/18.1.1/manjaro-xfce-18.1.1-191015-linux53.iso > MANJARO.iso
        LaunchFlash MANJARO
elif [ $response  -eq 3 ]
    then
         curl https://downloads.raspberrypi.org/raspbian_latest > RASPBIAN.iso
        LaunchFlash RASPBIAN   
elif [ $response  -eq 4 ]
    then 
    echo "What is the file name?(With extension ex: windows.iso)"
    read isoname
    hdiutil mount $isoname.iso
    df -h
    echo "What is the name of the windows volume mounted ex: /VOLUMES/CCCCOMA_X64FRE_FR-FR_DV9 (enter only name without /VOLUMES/)"
    read namemounted
    echo "Do you want to install the USB key in GPT or MBR"
    read biostable
    diskutil eraseDisk MS-DOS "WINDOWS" $biostable $diskfl
    cp -rpv /VOLUMES/$namemounted/* /Volumes/WINDOWS/
    
fi

