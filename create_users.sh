#!/bin/bash   
# Script som skapar användare, mappar och en välkomstfil

# Kontrollera så att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra scriptet som root!" 
  exit 1
fi

# Kontrollera att minst en användare skickas in 
if [ "$#" -eq 0 ]; then 
  echo "Användning: $0 användare1 användare2 ..."
  exit 1
fi

# Loopa igenom alla användare 
for user in "$@"
do
    # Skapa användare med hemkatalog om den inte finns 
    if id "$user" &>/dev/null; then
        echo "Användaren $user finns redan, hoppar över ..."
        continue
    fi

    useradd -m "$user"

    # Skapa mappar
    mkdir -p /home/"$user"/Documents
    mkdir -p /home/"$user"/Downloads
    mkdir -p /home/"$user"/Work

    # Sätt ägare
    chown -R "$user":"$user" /home/"$user"

    # Sätt rättigheter (endast ägaren) 
    chmod 700 /home/"$user"/Documents
    chmod 700 /home/"$user"/Downloads
    chmod 700 /home/"$user"/Work

    # Skapa welcome fil 
    echo "Välkommen $user" > /home/"$user"/welcome.txt
    echo "Andra användare i systemet:" >> home/"$user"/welcome.txt

    # Lista riktiga användare (UID >= 1000)
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd >> /home/"$user"/welcome.txt

    # Sätt rätt ägare på filen 
    chown "$user":"$user" /home/"$user"/welcome.txt

done
