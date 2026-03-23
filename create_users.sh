#!/bin/bash
# Script to create users and set up their environment
# This script creates users, sets up Documents, Downloads, Work folders,
# sets proper permissions, and creates a welcome file

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "You must run this script as root"
    exit 1
fi

# Loop through all users passed as arguments
for user in "$@"; do
    echo "Create user: $user"

    # Skip if user already exists
    if id "$user" &>/dev/null; then
        echo "User $user already exists, skipping..."
        continue
    fi

    # Create the user with a home directory
    useradd -m "$user"

    USER_HOME="/home/$user"

    # Create standard folders in the user's home directory
    mkdir -p "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"

    # Set ownership so the user owns their home directory and folders
    chown -R "$user:$user" "$USER_HOME"

    # Set permissions so only the user can access their home directory and folders
    chmod 700 "$USER_HOME" "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"

    # Create a welcome file in the user's home directory
    echo "Welcome $user" > "$USER_HOME/welcome.txt"

    # Append a list of all existing users on the system (excluding this new user)
    cut -d: -f1 /etc/passwd | grep -v -F "^$user$" >> "$USER_HOME/welcome.txt"

    # Ensure the user owns the welcome file
    chown "$user:$user" "$USER_HOME/welcome.txt"
done
