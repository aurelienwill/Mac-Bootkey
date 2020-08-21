echo ' ____   _____  _____ _____      _   __ _____ _   __  _____ _   _   __   __  ___  _____ '
echo '| ___ \|  _  ||  _  |_   _|    | | / /|  ___\ \ / / |  _  | \ | | |  \/  | / _ \/  __ \'
echo '| |_/ /| | | || | | | | |______| |/ / | |__  \ V /  | | | |  \| | | .  . |/ /_\ \ /  \/'
echo '| ___ \| | | || | | | | |______|    \ |  __|  \ /   | | | | . ` | | |\/| ||  _  | |    '
echo '| |_/ /\ \_/ /\ \_/ / | |      | |\  \| |___  | |   \ \_/ / |\  | | |  | || | | | \__/\'
echo '\____/  \___/  \___/  \_/      \_| \_/\____/  \_/    \___/\_| \_/ \_|  |_/\_| |_/\____/'

ExistFile()
{
	if [ -e $1 ]
		then
			result='true'
	else
		result='false'
			echo "File not found"
			exit
			fi
}
if [ -z $1 ]
	then
		ls *.iso
		echo " Please enter an ImageFile of Windows (with extension)"
		read WindowsImage
		ExistFile WindowsImage
		
else
	ExistFile $1
	WindowsImage=$1
fi 

#Montage de l'iso avec hdiutils / On enleve les espace & on cut pour avoir Le nom du disk sur lequel a été monter l'iso & le nom du volume
MountIso=$(hdiutil attach $WindowsImage | tr -s ' ')                                                                                           
DiskMounted=$(cut -d" " -f1 <<<$MountIso)
VolumeMounted=$(cut -d" " -f2 <<<$MountIso)
#Sur la dernier ligne que la commande Mount nous donne ,  on va chercher le dernier volume Monter & comparer dés que la clefs usb sera inserer.)
DiskList=$(mount |awk 'END {print}')
CompareDiskList=$DiskList
while [ "$DiskList" = "$CompareDiskList" ]  
do
	unset CompareDiskList
	CompareDiskList=$(mount |awk 'END {print}')
	echo "Insert the USBKEY /!/ Warning you will lost all your data on your usbkey"
	sleep 3
done
USBVolume=$(mount |awk 'END {print}' | cut -d" " -f3)
USBDisk=$(mount |awk 'END {print}' | cut -d" " -f1)
#On verifie la taille du fichier WIM car si > 4go le Fat32 ne prends pas en charge ...
WIMsize=du -sk "${USBMounted}/sources/install.wim" | awk '{print $1}'
echo "Do you want to install the USB key in GPT or MBR"
read PartitionTable
diskutil eraseDisk MS-DOS "WINDOWS" $PartitionTable $USBDisk
#Si le fichier >4Go on passe par Wimlib et on le split par paquet de 1go
if [ "$WIMsize" > 4000000 ]
then
rsync -avh --progress --exclude=sources/install.wim $VolumeMounted $USBVolume
wimlib-imagex split "${VolumeMounted}/sources/install.wim " "${USBVolume}/sources/install.swm" 1000
else
rsync -avh --progress $VolumeMounted $USBVolume
fi
