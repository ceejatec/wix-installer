import argparse
import fileinput
import re
import os
import shutil

# List of files containing absolute paths from the build machine
files = [
    'bin/erl.ini'
]

parser = argparse.ArgumentParser()
parser.add_argument('install_dir', type=str)
args = parser.parse_args()
install_dir = args.install_dir

# Couchbase.wxs passes the install_dir argument with an extra \FOO at the end,
# because [INSTALLDIR] in Wix has a trailing \ and there's no way to quote that
# without the command interpreter treating that as an escaped quote. :P
install_dir = install_dir[:-4]
full_files = [os.path.join(install_dir, fname) for fname in files]
path_regex = re.compile(r"C:/Jenkins/workspace/.*windows/install")
backslash_regex = re.compile(r"\\")

# Replace build-machine install path with target installation dir
for line in fileinput.input(full_files, inplace=1):
    line = path_regex.sub(install_dir, line)
    print backslash_regex.sub("/", line)

# Finally, copy erl.ini into the erts dist directory as well
shutil.copy(os.path.join(install_dir, "bin", "erl.ini"),
            os.path.join(install_dir, "erts-5.10.4.0.0.1", "bin"))
