#!/bin/zsh

###
### sourcing config file
###

if [[ -f ~/.shellscriptsrc ]]; then . ~/.shellscriptsrc; else echo '' && echo -e '\033[1;31mshell script config file not found...\033[0m\nplease install by running this command in the terminal...\n\n\033[1;34msh -c "$(curl -fsSL https://raw.githubusercontent.com/tiiiecherle/osx_install_config/master/_config_file/install_config_file.sh)"\033[0m\n' && exit 1; fi
eval "$(typeset -f env_get_shell_specific_variables)" && env_get_shell_specific_variables



###
### launchd & applescript to do things when changing network location
###

### installation should be done via restore script after first install

# copy to /Users/$USER/Library/Scripts/
rm -rf /Users/"$USER"/Library/Scripts/run_on_network_change.scpt
cp -a "$SCRIPT_DIR"/install_files/run_on_network_change.scpt /Users/"$USER"/Library/Scripts/run_on_network_change.scpt
chown "$USER":staff /Users/$USER/Library/Scripts/run_on_network_change.scpt
chmod 750 /Users/$USER/Library/Scripts/run_on_network_change.scpt

# change username in file and
# copy to ~/Library/LaunchAgents/
cp -a "$SCRIPT_DIR"/install_files/com.run_script_on_network_change.plist /Users/"$USER"/Library/LaunchAgents/com.run_script_on_network_change.plist
chown "$USER":staff ~/Library/LaunchAgents/com.run_script_on_network_change.plist
chmod 640 ~/Library/LaunchAgents/com.run_script_on_network_change.plist

# do NOT copy to /Library/LaunchAgents/ or the app will not be restartable when quit through the script
# do not try to watch the file /etc/resolv.conf in the script cause it has some „changed date“ and permission issues


### enable service
# if kill was used to stop the service kickstart is needed to restart it, bootstrap will not work
launchctl bootout gui/"$(id -u "$USER")"/com.run_script_on_network_change 2>&1 | grep -v "in progress" | grep -v "No such process"
#launchctl kill 15 gui/"$(id -u "$USER")"/com.run_script_on_network_change
sleep 2
launchctl bootstrap gui/"$(id -u "$USER")" ~/Library/LaunchAgents/com.run_script_on_network_change.plist 2>&1 | grep -v "in progress" | grep -v "already bootstrapped"
launchctl enable gui/"$(id -u "$USER")"/com.run_script_on_network_change
sleep 2


### uninstall
uninstall_run_on_network_change() {
	launchctl bootout gui/"$(id -u "$USER")"/com.run_script_on_network_change 2>&1 | grep -v "in progress" | grep -v "No such process"
	sleep 2
	#launchctl kill 15 gui/"$(id -u "$USER")"/com.run_script_on_network_change
	launchctl disable gui/"$(id -u "$USER")"/com.run_script_on_network_change
	rm -rf ~/Library/Scripts/run_on_network_change_login.app
	rm -f ~/Library/LaunchAgents/com.run_script_on_network_change.plist
}
#uninstall_run_on_network_change

echo "done"
