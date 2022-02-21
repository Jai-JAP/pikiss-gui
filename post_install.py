#!/usr/bin/env python3

import os
import subprocess


print('\n'*2)
"""
Create categories
"""
print('Creating PiKISS GUI category dirs...')
from_cat = os.path.normpath(os.getcwd() + os.sep + os.pardir) + os.path.join(os.sep, 'data', 'categories', '.')
datadir = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'pikiss-gui') + os.sep
subprocess.call(['cp', '-R', from_cat, datadir])
print('PiKISS GUI category dirs created successfully.\n')


"""
Create PiKISS GUI menuentry
"""
print('Creating PiKISS GUI menuentry...')
menuentrypath = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'applications') + os.sep
execpath = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'bin', 'pikiss-gui')
iconpath = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'icons', 'pikiss-gui.png')

with open(menuentrypath + 'pikiss-gui.desktop', 'w') as f:
    print('[Desktop Entry]', file=f)
    print('Name=PiKISS GUI', file=f)
    print('GenericName=PiKISS', file=f)
    print('Comment=GTK frontend for PiKISS', file=f)
    print('Categories=Utility;', file=f)
    print('Exec=' + execpath, file=f)
    print('Icon=' + iconpath, file=f)
    print('Terminal=true', file=f)
    print('Type=Application', file=f)
    print('StartupNotify=true', file=f)
    
subprocess.call(['chmod', 'a+x', menuentrypath + 'pikiss-gui.desktop'])
print('PiKISS GUI menuentry created successfully.\n')


"""
Create App import script
"""
getappssh = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'pikiss-gui', 'getapps.sh')
print('Creating App import script...')
#Create getapps.sh
with open(getappssh, 'w') as f:
    print('#!/bin/bash/n/n', file=f)
    print('## Apps Refresh Script for PiKISS GUI', file=f)
    print('## By Jai-JAP <jai.jap.318@gmail.com>\n', file=f)
    print('## getapps script autogenerated at install\n', file=f)
    print('echo -e "\\x1b[1;5;93mThis script may ask you for your password. \\nPlease enter your password if asked.\\x1b[0m\\n"', file=f)
    print('echo -en "\\x1b[1;92mPress [ENTER] to continue.\\x1b[0m" ; read -p ""', file=f)
    print('declare -a categories=("Tweaks" "Games" "Emulators" "Info" "Multimedia" "Configure" "Internet" "Server" "Devs" "Others")', file=f)
    print('for category in "${categories[@]}";', file=f)
    print('  do ', file=f)
    print('    awk -v smcat="sm$category" \'$0~smcat{f=1; next} /done/{f=0} f\' $HOME/piKiss/piKiss.sh | ', file=f)
    print('    awk \'/esac/{f=0} f; /Back\) break ;;/{f=1}\' | sed -r \'s/\)/.sh/g\' | sed -r \'s/VSCode\/ium/VSCodium/g\' | ', file=f)
    print('    sed -r \'s/.\/scripts/~\/piKiss\/scripts/g\' | tr -d \';\' | grep -v uninstall_pikiss | ', file=f)
    print('    awk -v inst="' + datadir + '$category/" \'{print "sudo ln -s ",$2,inst$1,"2>/dev/null"}\' | bash ', file=f)
    print('  done\n', file=f)
    print('sudo find ' + datadir + ' -xtype l -delete', file=f)
    print('echo -en "\\n\\x1b[1;92mPiKISS Apps successfully synced.\\x1b[0m\\n"\n', file=f)
    print('x=10', file=f)
    print('tput civis', file=f)
    print('while [ $x -ge 0 ]', file=f)
    print('  do ', file=f)
    print('    echo -en "\\x1b[1;93mWaiting $x seconds before exiting...\\x1b[0m\\r"', file=f)
    print('    sleep 1', file=f)
    print('    x=$(( $x - 1 ))', file=f)
    print('  done', file=f)
    print('echo -e "\\x1b[0J"', file=f)
    print('tput cvvis', file=f)
    print('exit 0', file=f)

subprocess.call(['chmod', 'a+x', getappssh ])
print('App import script created successfully.\n')


"""
Create PiKISS GUI Sync Apps menuentry
"""
print('Creating PiKISS GUI Sync Apps menuentry...')
with open(menuentrypath + 'pikiss-gui-sync-apps.desktop', 'w') as f:
    print('[Desktop Entry]', file=f)
    print('Name=PiKISS GUI Sync Apps', file=f)
    print('GenericName=PiKISS App Sync', file=f)
    print('Comment=Sync Apps with PiKISS', file=f)
    print('Categories=Utility;', file=f)
    print('Exec=' + getappssh, file=f)
    print('Icon=' + iconpath, file=f)
    print('Terminal=true', file=f)
    print('Type=Application', file=f)
    print('StartupNotify=true', file=f)
    
subprocess.call(['chmod', 'a+x', menuentrypath + 'pikiss-gui-sync-apps.desktop'])
print('PiKISS GUI Sync Apps menuentry created successfully.')
print('\x1b[1;92mFor resyncing apps with PiKISS use menu launcher \x1b[1;91m"PiKISS GUI Sync Apps"\x1b[0m\n')


"""
Creating uninstall.sh
"""
uninstallsh = os.path.normpath(os.getcwd() + os.sep + os.pardir) + os.sep + 'uninstall.sh'
print('Creating uninstall script')

with open(uninstallsh, 'w') as f:
    print('#!/bin/bash\n', file=f)
    print('## PiKISS GUI Uninstall script autogenerated at install\n\n{', file=f)
    print('sudo ninja -C build\ uninstall', file=f)
    print('sudo rm ' + menuentrypath + 'pikiss-gui*.desktop ', file=f)
    print('sudo rm -rf ' + datadir, file=f)
    print('echo PiKISS directories successfully removed', file=f)
    print('sudo rm -f ' + uninstallsh + '\n}', file=f)

subprocess.call(['chmod', 'a+x', uninstallsh ])
print('Uninstall script created successfully.\n')


"""
Syncing Apps
"""
print('Syncing Apps with PiKISS...\n\n')
user = os.environ['SUDO_USER']
subprocess.call(['su', user, getappssh])