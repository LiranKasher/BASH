#!/bin/bash
# This script creates a new SFTP user for customers. It limits the access to their upload folder,
# limits the login only to SFTP protocol (no Shell), and generates an 8 characters random password,
# using most of the useable characters on your keyboard (just like the CISO ordered) :)

username=""
if [ "$1" != "" ];
    then
    username="$1";
fi;

if [ $(id -u) -eq 0 ]; then
   if [ "$username" == "" ];
   then
       #username=$(read -p "Enter username : ")
	   read -p "Enter username : " username
   fi;
   password=$(< /dev/urandom tr -dc _A-Z-a-z-#-@ | head -c${1:-8})
   echo "Password is: $password"
   egrep "^$username" /etc/passwd >/dev/null
   if [ $? -eq 0 ]; then
	   echo "$username already exists!"
       exit 1
   else
       pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
       useradd -p $pass $username
       [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
   fi
else
   echo "Only root may add a user to the system"
   exit 2
fi

mkdir /var/ftp/customers/$username

chown root:$username /var/ftp/customers/$username
chmod 755 /var/ftp/customers/$username
usermod -s /bin/false $username

echo " Match User $username
      ChrootDirectory /var/ftp/customers/$username
      ForceCommand internal-sftp" >>/etc/ssh/sshd_config
mkdir /var/ftp/customers/$username/upload
chown $username:$username /var/ftp/customers/$username/upload
chmod 755 /var/ftp/customers/$username/upload

systemctl restart sshd.service
