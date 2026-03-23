#!/bin/bash
# Script to create users and set up their environment
# Följer provets krav: skapar användare, hemkatalog, mappar och welcome.txt

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste köra scriptet som root"
    exit 1
fi

# Loopa genom alla användarnamn som skickas som argument
for user in "$@"; do
    echo "Skapar användare: $user"

    # Hoppa över om användaren redan finns
    if id "$user" &>/dev/null; then
        echo "Användaren $user finns redan, hoppar över..."
        continue
    fi

    # Skapa användaren med hemkatalog och bash som shell
    useradd -m -s /bin/bash "$user"

    USER_HOME="/home/$user"

    # Skapa standardmappar
    mkdir -p "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"

    # Sätt ägarskap
    chown -R "$user:$user" "$USER_HOME"

    # Sätt rättigheter så bara användaren kan läsa/skriva
    chmod 700 "$USER_HOME" "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"

    # Skapa welcome.txt med personligt meddelande och lista på andra användare
    echo "Välkommen $user" > "$USER_HOME/welcome.txt"
    cut -d: -f1 /etc/passwd | grep -v -F "^$user$" >> "$USER_HOME/welcome.txt"
    chown "$user:$user" "$USER_HOME/welcome.txt"
done
   
