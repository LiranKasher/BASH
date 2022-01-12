#!/bin/bash
# This script deletes SFTP users on demand.
# It removes the users, their home, mail and data directories.
# It also removes login permissions from the SSHD config file, thus keeping it slim and neat.  

if [ $(id -u) -eq 0 ]; then
        read -p "Warning! This is a permanent change and cannot be undone!
        Please enter username/s to be deleted (seperated with space): " user_list
        declare -a StringArray=($user_list)
        for i in ${StringArray[@]}; do
                username=$i
                userdel $username
                rm -rf /var/spool/mail/$username /home/$username /datadisk1/customers/$username
                sed -in "/$username/,+2 d" /etc/ssh/sshd_config
        done
        echo The following users have been deleted:
        echo $user_list
fi
