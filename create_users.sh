#!/bin/bash 
# Script to create users and set up their environment 
# This script creates users, sets up Documents, Downloads, Work folders
# sets proper permissions and creates a welcome file

# Check if script is run as root
#!/bin/bash
# Script to create users and set up their environment

if [ "$EUID" -ne 0 ]; then
    echo "You must run this script as root"
    exit 1
fi

for user in "$@"; do
    echo "Create user: $user"

    # Skip if user already exists
    if id "$user" &>/dev/null; then
        echo "User $user already exists, skipping..."
        continue
    fi

    # Create user with home directory
    useradd -m -s /bin/bash "$user"

    USER_HOME="/home/$user"

    # Create standard folders
    mkdir -p "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"

    # Set ownership
    chown -R "$user:$user" "$USER_HOME"

    # Set permissions
    chmod 700 "$USER_HOME" "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"

    # Create welcome file
    echo "Välkommen $user" > "$USER_HOME/welcome.txt"
    cut -d: -f1 /etc/passwd | grep -v -F "^$user$" >> "$USER_HOME/welcome.txt"

    # Optional: set default password
    # echo "$user:changeme" | chpasswd

done

   
