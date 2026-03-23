#!/bin/bash 
# Script to create users and set up their environment 
# This script creates users, sets up Documents, Downloads, Work folders
# sets proper permissions and creates a welcome file

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
echo "You must run this script as root"
exit 1
fi

# Loop through all users passed as arguments
for user in "$@"
do
   echo "Create user: $user"

# Create the user with a home directory
useradd -m "$user"

# Create standard folders in the users home directory
mkdir -p /home/$user/Documents
mkdir -p /home/$user/Downloads
mkdir -p /home/$user/Work

# Set ownership so the user owns their home directory and folders
chown -R $user:$user  /home/$user

# Set permissions so only the user can access their home directory
chmod -R 700 /home/$user

# Create a welcome file in the users home directory
echo "Välkommen $user" > /home/$user/welcome.txt

# Append a list of all existing users on the system
cut -d: -f1 /etc/passwd | grep -v "^$user$" >> /home/$user/welcome.txt

done


   
