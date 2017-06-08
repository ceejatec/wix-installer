import argparse
from datetime import datetime
import os

parser = argparse.ArgumentParser()
parser.add_argument('install_dir', type=str)
args = parser.parse_args()
# Couchbase.wxs passes the install_dir argument with an extra \FOO at the end,
# because [INSTALLDIR] in Wix has a trailing \ and there's no way to quote that
# without the command interpreter treating that as an escaped quote. :P
install_dir = args.install_dir[:-4]
backup_dir = "backup-" + datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
os.rename(os.path.join(install_dir, "var"),
    os.path.join(install_dir, backup_dir))
