#!/bin/bash

## Apps Refresh Script for PiKISS GUI
## By Jai-JAP <jai.jap.318@gmail.com>

declare -a categories=("Tweaks" "Games" "Emulators" "Info" "Multimedia" "Configure" "Internet" "Server" "Devs" "Others")
for category in "${categories[@]}";
  do 
    #echo sm${category}
    #cd /usr/local/share/pikiss-gui/${category}
    awk -v smcat="sm$category" '$0~smcat{f=1; next} /done/{f=0} f' $HOME/piKiss/piKiss.sh |  
    awk '/esac/{f=0} f; /Back\) break ;;/{f=1}' | sed -r 's/\)/.sh/g' | sed -r 's/VSCode\/ium/VSCodium/g' | 
    sed -r 's/.\/scripts/~\/piKiss\/scripts/g' | tr -d ';' | grep -v uninstall_pikiss |
    awk -v inst="/usr/local/share/pikiss-gui/$category/" '{print "sudo ln -s ",$2,inst$1}' | bash 2>&1 | grep -v "File Exists"
  done

DIR=$(pwd)
cd /usr/local/share/pikiss-gui/
sudo find -xtype l -delete
cd $DIR