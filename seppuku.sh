#!/bin/bash

#<<! CAREFUL! THIS SCRIPT WILL DESTOY ANY MAC WITH T CHIP FOREVER! !>>

UserName="<! ADMIN USERNAME HERE !>"
AuthPassowrd="<! ADMIN PASSWORD HERE !>"
FWPassowrd="<! RECOVERY PASSWORD HERE !>"

if [[ $EUID != 0 ]]; then
	echo "This program needs to run as root."
	exit 1
fi

newAuthPassowrd="$(openssl rand -hex 128)"
newFWPassword="$(openssl rand -hex 128)"

/usr/bin/expect <<EOF
spawn passwd $UserName
expect "Old Password"
send "$AuthPassowrd\r"
expect "New Password"
send "$newAuthPassowrd\r"
expect "Retype New Password"
send "$newAuthPassowrd\r"
expect ""
interact
EOF

/usr/bin/expect <<EOF
spawn firmwarepasswd -setpasswd
expect "Enter password:"
send "$FWPassowrd\r"
expect "Enter new password:"
send "$newFWPassword\r"
Re-enter new password:
send "$newFWPassword\r"
expect ""
interact
EOF
