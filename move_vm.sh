#!/bin/bash
virsh list --all
read -p "Enter a vm to migrate > " vmname
read -p "Enter a remote server name > " remotehostname
echo "ssh-copy-id to:" $vmname
ssh-copy-id $vmname
virsh migrate --live $vmname qemu+ssh://$remotehostname/system --copy-storage-all --verbose
echo "Let's confirm it's up"
ssh $vmname
while true; do
read -p "Would you like to delete it locally? (y/n) " yn
case $yn in 
	[yY] ) echo deleting $vmnamed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac
done
virsh undefine $vmname --remove-all-storage
echo "Let's confirm it's up"
ssh $vmname
echo "What's left:"
virsh list --all
exit
