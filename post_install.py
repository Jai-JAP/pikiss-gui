#!/usr/bin/env python3

import os
import subprocess

hicolor = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'icons', 'hicolor')

if not os.environ.get('DESTDIR'):
    print('Updating icon cache...')
    subprocess.call(['gtk-update-icon-cache', '-q', '-t' ,'-f', hicolor])


"""
Create categories
"""
from_cat = os.path.normpath(os.getcwd() + os.sep + os.pardir) + os.path.join(os.sep, 'data', 'categories', '.')
to_cat = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'pikiss-gui') + os.sep
subprocess.call(['cp', '-R', from_cat, to_cat])