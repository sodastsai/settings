#!/usr/bin/env python
from __future__ import absolute_import, division, unicode_literals, print_function

import os
import sys

import shutil
import six
import yaml

# noinspection PyShadowingBuiltins
input = six.moves.input

# Main -----------------------------------------------------------------------------------------------------------------

# Get settings file
if len(sys.argv) > 1:
    settings_path = sys.argv[1]
else:
    settings_path = "settings.yaml"
with open(settings_path, "r") as f:
    settings = yaml.load(f)
if not settings:
    sys.exit(0)

# Normalize paths
settings = {os.path.normpath(src_path): os.path.normpath(os.path.expanduser(dest_path))
            for src_path, dest_path in settings.items()}

# Enumerate paths in settings
for src_path, dest_path in settings.items():
    print("From \033[33m{}\033[m to \033[32m{}\033[m".format(src_path, dest_path))

# Confirmation
confirmation = None
while confirmation is None:
    input_confirmation = input("Sure? [y/N] ").lower()
    if input_confirmation == "y":
        confirmation = True
    elif input_confirmation == "n":
        confirmation = False
if not confirmation:
    sys.exit(0)

# Go
for src_path, dest_path in settings.items():
    shutil.copyfile(src_path, dest_path)
