#!/bin/bash

###
### ownerships and permissions
###

# checking if SELECTEDUSER is exported from restore script
if [ "$SELECTEDUSER" == "" ]
then
    #SELECTEDUSER="$USER"
    SELECTEDUSER="$(who | grep console | awk '{print $1}')"
    # asking for the administrator password upfront
    sudo -v
    # keep-alive: update existing 'sudo' time stamp until script is finished
    while true; do sudo -n true; sleep 600; kill -0 "$$" || exit; done 2>/dev/null &
    #echo "user is $SELECTEDUSER"
else
    #echo "SELECTEDUSER is $SELECTEDUSER"
    :
fi
HOMEFOLDER=Users/"$SELECTEDUSER"
#echo "HOMEFOLDER is /"$HOMEFOLDER""

# starting a function to tee a record to a logfile
function backup_restore_permissions {

# app permissions in applications folder
echo "setting ownerships and permissions in /Applications..."
find "/Applications" -mindepth 1 ! -group wheel ! -path "*/*.app/*" -name "*.app" -print0 | xargs -0 sudo chmod 755
find "/Applications" -mindepth 1 ! -group wheel ! -path "*/*.app/*" -name "*.app" -print0 | xargs -0 sudo chown 501:admin
if [ -e /Applications/VirtualBox.app ]; then sudo chown root:admin /Applications/VirtualBox.app; else :; fi
#sudo chmod 644 "/Applications/.DS_Store"

# color profiles
echo "setting ownerships and permissions outside the user folder..."
if [ -e "/Library/Application Support/Adobe/Color/Profiles/Recommended/profiles_tom" ]
then
    sudo chmod 755 "/Library/Application Support/Adobe/Color/Profiles/Recommended/profiles_tom"
    sudo chown root:admin "/Library/Application Support/Adobe/Color/Profiles/Recommended/profiles_tom"
    find "/Library/Application Support/Adobe/Color/Profiles/Recommended/profiles_tom" -maxdepth 1 -type f -print0 | xargs -0 sudo chmod 644
    find "/Library/Application Support/Adobe/Color/Profiles/Recommended/profiles_tom" -maxdepth 1 -type f -print0 | xargs -0 sudo chown root:wheel
else
    :
fi

# display profiles
if [ -e "/Library/ColorSync/Profiles/Displays" ]
then
    find "/Library/ColorSync/Profiles/Displays" -maxdepth 1 -type f -print0 | xargs -0 sudo chmod 644
    find "/Library/ColorSync/Profiles/Displays" -maxdepth 1 -type f -print0 | xargs -0 sudo chown root:wheel
else
    :
fi

# google earth web plugin
if [ -e "/Library/Internet Plug-Ins/Google Earth Web Plug-in.plugin" ]
then
    sudo chmod 755 "/Library/Internet Plug-Ins/Google Earth Web Plug-in.plugin"
    sudo chown root:wheel "/Library/Internet Plug-Ins/Google Earth Web Plug-in.plugin"
else
    :
fi

# canon printer driver
if [ -e "/Library/Printers/PPDs/Contents/Resources/CNMCIRAC3325S2.ppd.gz" ]
then
    sudo chmod 644 "/Library/Printers/PPDs/Contents/Resources/CNMCIRAC3325S2.ppd.gz"
    sudo chown root:admin "/Library/Printers/PPDs/Contents/Resources/CNMCIRAC3325S2.ppd.gz"
else
    :
fi

if [ -e "/Library/Printers/Canon/CUPSPS2 " ]
then
    sudo chown -R root:admin "/Library/Printers/Canon/CUPSPS2 "
    sudo chmod -R 755 "/Library/Printers/Canon/CUPSPS2 "
    sudo find /Library/Printers/Canon -type f -name "*.nib" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*.DAT" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*.TBL" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*.icc" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*.icns" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*.plist" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*.strings" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*.png" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. gif" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. html" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. js" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. gif" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. jpg" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. css" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. xib" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. helpindex" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "*. PRF" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "CodeResources" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "CodeDirectory" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "CodeRequirements" -print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "CodeSignature"-print0 | xargs -0 sudo chmod 644
    sudo find /Library/Printers/Canon -type f -name "PkgInfo" -print0 | xargs -0 sudo chmod 644
else
    :
fi

# custom scripts
if [ -e "/Library/Scripts/custom/" ]
then
    sudo chown -R root:wheel "/Library/Scripts/custom/"
    sudo chmod -R 755 "/Library/Scripts/custom/"
else
    :
fi

# launchd hostsfile
if [ -e "/Library/LaunchDaemons/com.hostsfile.install_update.plist" ]
then
    sudo chown root:wheel "/Library/LaunchDaemons/com.hostsfile.install_update.plist"
    sudo chmod 644 "/Library/LaunchDaemons/com.hostsfile.install_update.plist"
else
    :
fi

# mysides
if [ -e "/usr/local/bin/mysides" ]
then
    sudo chown root:wheel "/usr/local/bin/mysides"
    sudo chmod 755 "/usr/local/bin/mysides"
else
    :
fi

# cups printer
if [ -e "/etc/cups/printers.conf" ]
then
    sudo chown root:_lp "/etc/cups/printers.conf"
    sudo chmod 600 "/etc/cups/printers.conf"
else
    :
fi
if [ -e "/etc/cups/ppd/" ]
then
    sudo chown -R root:_lp "/etc/cups/ppd/"
    sudo find /etc/cups/ppd/ -type f -print0 | sudo xargs -0 chmod 644
else
    :
fi

# user folder ~
echo "setting ownerships and permissions inside the user folder..."
#echo "SELECTEDUSER is $SELECTEDUSER"
# dscl . -read /Users/$USER UniqueID
# id
# 501=UID of user
# 80=group admin

# reset acls (only for repair)
#sudo chmod -R -N /"$HOMEFOLDER"/*

# setting ownership and permissions
#sudo chown -R 501:staff /"$HOMEFOLDER"/.*

# apple support advice
# https://support.apple.com/en-us/HT203538
#chflags -R nouchg /"$HOMEFOLDER"
#diskutil resetUserPermissions / `id -u`

sudo find /"$HOMEFOLDER" -mount ! -path "*/*.app/*" -not -path "/"$HOMEFOLDER"/Desktop/restore/*" -type f -print0 | sudo xargs -0 chown 501:staff
sudo find /"$HOMEFOLDER" -mount ! -path "*/*.app/*" -not -path "/"$HOMEFOLDER"/Desktop/restore/*" ! -name "*.app" -type d -print0 | sudo xargs -0 chown 501:staff
sudo find /"$HOMEFOLDER" -mount ! -path "*/*.app/*" -not -path "/"$HOMEFOLDER"/Desktop/restore/*" -type f -print0 | sudo xargs -0 chmod 600
sudo find /"$HOMEFOLDER" -mount ! -path "*/*.app/*" -not -path "/"$HOMEFOLDER"/Desktop/restore/*" ! -name "*.app" -type d -print0 | sudo xargs -0 chmod 700

#sudo chmod -R u+rwX /"$HOMEFOLDER"/.*
sudo chown root:wheel /Users
sudo chmod 755 /Users
sudo chmod 755 /"$HOMEFOLDER"
sudo chmod 777 /"$HOMEFOLDER"/Public
sudo chmod 733 /"$HOMEFOLDER"/Public/Drop\ Box
sudo find /"$HOMEFOLDER" -mount ! -path "*/*.app/*" -not -path "/"$HOMEFOLDER"/Desktop/restore/*" ! -name "*.app" -name "*.sh" -type f -print0 | sudo xargs -0 chmod 700
#
if [ -e /"$HOMEFOLDER"/Library/Services/ ] && [ $(ls -A /"$HOMEFOLDER"/Library/Services/) ]
then
    sudo chmod 700 /"$HOMEFOLDER"/Library/Services/*
else
    :
    #echo directory does not exist or is empty...
fi
#
if [ -e /"$HOMEFOLDER"/Library/Widgets/ ] && [ $(ls -A /"$HOMEFOLDER"/Library/Widgets/) ]
then
    sudo find /"$HOMEFOLDER"/Library/Widgets -type f -print0 | sudo xargs -0 chmod 644
    sudo chmod 755 /"$HOMEFOLDER"/Library/Widgets/*
else
    :
    #echo directory does not exist or is empty...
fi
#
if [ -e /"$HOMEFOLDER"/Library/Application\ Scripts/com.apple.mail/ ] && [ $(ls -A /"$HOMEFOLDER"/Library/Application\ Scripts/com.apple.mail/) ]
then
    sudo chmod 750 /"$HOMEFOLDER"/Library/Application\ Scripts/com.apple.mail/*
else
    :
    #echo directory does not exist or is empty...
fi

# homebrew permissions
#if [ -e "$(brew --prefix)" ] 
#then
#	echo "setting ownerships and permissions for homebrew..."
#	BREWGROUP="admin"
#	BREWPATH=$(brew --prefix)
#	sudo chown -R 501:"$BREWGROUP" "$BREWPATH"
#	sudo find "$BREWPATH" -type f -print0 | sudo xargs -0 chmod g+rw
#	sudo find "$BREWPATH" -type d -print0 | sudo xargs -0 chmod g+rwx
#else
#	:
#fi

# script finfished
echo "done setting ownerships and permissions ;)"

}

# running function to tee a record to a logfile
if [ ! /"$HOMEFOLDER"/Desktop/backup_restore_log.txt ]; then touch /"$HOMEFOLDER"/Desktop/backup_restore_log.txt; else :; fi

echo "SELECTEDUSER is $SELECTEDUSER"
# checking if the script is run as root
if [ $EUID != 0 ];
then
    #export -f backup_restore_permissions
    #su "$SELECTEDUSER" -c 'backup_restore_permissions | tee -a /"$HOMEFOLDER"/Desktop/backup_restore_log.txt'
    FUNC=$(declare -f backup_restore_permissions)
    sudo bash -c "SELECTEDUSER="$SELECTEDUSER"; HOMEFOLDER="$HOMEFOLDER"; $FUNC; backup_restore_permissions"
else
    backup_restore_permissions | tee -a /"$HOMEFOLDER"/Desktop/backup_restore_log.txt
fi



