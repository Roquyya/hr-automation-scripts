#!/bin/bash

read -p "Enter the user name to offboard: " username

#check if the user exists. 
if ! id "$username" &>/dev/null; then
   echo "Error: User '$username' does not exists."
   exit 1

fi

#create a backup directory if it doesn't exist, then archive

backup_dir="/var/backup/archived_users"
mkdir -p "$backup_dir"

home_dir="/home/$username"
archive_name="${username}_archive_$(date +%F).tar.gz"


if [ -d "$home_dir" ]; then
   sudo tar -czf "$backup_dir/$archive_name" "$home_dir"
else
   echo "Warning: Home directory for '$username' not found. "
fi

#Lock the user account. Prevent future logins. 

sudo passwd -l "$username"

#to delete the user account
sudo userdel "$username"

#print success message.

echo "user '$username' has been offboarded."
echo " Home directory archived as: $backup_dir/$archive_name"
echo "Account has been locked and user deleted." 


