#!/bin/bash
echo -e '\n\n'

#Create categories
echo 'Creating PiKISS GUI category dirs...'
from_cat="${MESON_SOURCE_ROOT}/data/categories/."
datadir="${MESON_INSTALL_PREFIX}/share/pikiss-gui/"
cp -R ${from_cat} ${datadir}

echo -e 'PiKISS GUI category dirs created successfully.\n'


#Create PiKISS GUI menuentry
echo 'Creating PiKISS GUI menuentry...'
menuentrypath="${MESON_INSTALL_PREFIX}/share/applications/"
execpath="${MESON_INSTALL_PREFIX}/bin/pikiss-gui"
iconpath="${MESON_INSTALL_PREFIX}/share/icons/pikiss-gui.png"

cat << EOF > ${menuentrypath}pikiss-gui.desktop
[Desktop Entry]
Name=PiKISS GUI
GenericName=PiKISS
Comment=GTK frontend for PiKISS
Categories=Utility;
Exec=${execpath}
Icon=${iconpath}
Terminal=false
Type=Application
StartupNotify=true
EOF

chmod a+x "${menuentrypath}pikiss-gui.desktop"
echo -e 'PiKISS GUI menuentry created successfully.\n'


#Create App import script
#Gettig configs
getopt(){
  grep $1 "${MESON_BUILD_ROOT}/config.h" | awk '{print $3}' | tr -d '"' 
}
pikiss=$(getopt 'pikiss_script')
pikissdir=$(getopt 'pikissdir')
getappssh="${MESON_INSTALL_PREFIX}/share/pikiss-gui/getapps.sh"

echo 'Creating App import script...'
#Create getapps.sh
cat << EOF > ${getappssh}
#!/bin/bash


## Apps Refresh Script for PiKISS GUI
## By Jai-JAP <jai.jap.318@gmail.com>

## getapps script autogenerated at install

# echo -e "\\x1b[1;5;93mThis script may ask you for your password. \\nPlease enter your password if asked.\\x1b[0m\\n"
# echo -en "\\x1b[1;92mPress [ENTER] to continue.\\x1b[0m" ; read -p ""

disabled_apps=\$(grep "[[:blank:]]# " ${pikiss} | awk '{print $2}' | tr '\\n' '|' | sed 's/|$//')

declare -a categories=("Tweaks" "Games" "Emulators" "Info" "Multimedia" "Configure" "Internet" "Server" "Devs" "Others")
for category in "${categories[@]}";
  do
    awk -v smcat="sm\$category" '\$0~smcat{f=1; next} /done/{f=0} f' ${pikiss} | 
    awk '/esac/{f=0} f; /Back\) break ;;/{f=1}' | sed -r 's+\)+.sh+g' | sed -r 's|VSCode/ium|VSCodium|g' | 
    sed -r 's|./scripts| ${pikissdir}/scripts|g' | tr -d ';' | grep -v uninstall_pikiss | grep -v -E "\$disabled_apps" | 
    awk -v inst="${datadir}\$category/" '{print "sudo ln -s ",\$2,inst\$1,"2>/dev/null"}' | bash 
    echo .
  done

sudo find ${datadir} -xtype l -delete
echo -en "\\n\\x1b[1;92mPiKISS Apps successfully synced.\\x1b[0m\\n"

x=10
tput civis
while [ \$x -ge 0 ]
  do 
    echo -en "\\x1b[1;93mWaiting \$x seconds before exiting...\\x1b[0m\\r"
    sleep 1
    x=\$(( \$x - 1 ))
  done
echo -e "\\x1b[0J"
tput cvvis
exit 0
EOF

chmod a+x "${getappssh}" 
echo -e 'App import script created successfully.\n'


#Create PiKISS GUI Sync Apps menuentry
echo 'Creating PiKISS GUI Sync Apps menuentry...'
cat << EOF > ${menuentrypath}pikiss-gui-sync-apps.desktop
Desktop Entry]
Name=PiKISS GUI Sync Apps
GenericName=PiKISS App Sync
Comment=Sync Apps with PiKISS
Categories=Utility;
Exec=${getappssh}
Icon=${iconpath}
Terminal=true
Type=Application
StartupNotify=true
EOF
    
chmod a+x "${menuentrypath}pikiss-gui-sync-apps.desktop"
echo 'PiKISS GUI Sync Apps menuentry created successfully.'
echo -e '\x1b[1;92mFor resyncing apps with PiKISS use menu launcher \x1b[1;91m"PiKISS GUI Sync Apps"\x1b[0m\n'


#Creating uninstall.sh
uninstallsh=${MESON_BUILD_ROOT}/uninstall.sh
echo 'Creating uninstall script'
cat << EOF > $uninstallsh
#!/bin/bash

## PiKISS GUI Uninstall script autogenerated at install

{
sudo ninja -C build uninstall
sudo rm ${menuentrypath}pikiss-gui*.desktop
sudo rm -rf ${datadir}
echo PiKISS directories successfully removed
sudo rm -f ${uninstallsh}
}
EOF

chmod a+x $uninstallsh
echo -e 'Uninstall script created successfully.\n'


#Syncing Apps
echo -e 'Syncing Apps with PiKISS...\n\n'
su $SUDO_USER ${getappssh}