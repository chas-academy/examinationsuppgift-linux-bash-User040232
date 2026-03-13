#!/bin/bash   - (#) script som skapar användare och mappar 

# kontrollera så att scriptet körs som root
if [ $EUID -ne 0 ]; then
echo "måste köra scriptet som root!" 
exit 
fi

# gå igenom alla användare som skickas in 
for user in "$@"
do

# skapa användare med hemkatalog useradd -m $user

# skapa mappar
mkdir /home/$user/Documents
mkdir /home/$user/Downloads
mkdir /home/$user/Work

# ändra ägare till användaren
chown -R $user:$user /home/$user

# lägger rättigheter så bara ägaren kan läsa/skriva 
chmod 700 /home/$user/Documents
chmod 700 /home/$user/Downloads
chmod 700 /home/$user/Work

# skapa welcome fil 
echo "Välkommen $user" > /home/$user/welcome.txt
echo "Andra användare i systemet:" >> home/$user/welcome.txt

# lista användare 
cut -d: -f1 /etc/passwd >> /home/$user/welcome.txt

# sätta rätt ägare på filen 
chown $user:$user /home/$user/welcome.txt

done
