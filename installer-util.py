import argparse
from datetime import datetime
import os
import re
import shutil
import fileinput
import socket
import time
from string import Template

"""
Functions meant to be called by various stages of the Windows installer.
All in one Python file so they can be compiled into a single .exe.
"""
def do_backup_var(install_dir, _):
  """
  Backs up (actually renames) the "var" directory based on the current
  date/time
  """
  backup_dir = "backup-" + datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
  os.rename(os.path.join(install_dir, "var"),
    os.path.join(install_dir, backup_dir))

def do_fixpaths(install_dir, _):
  """
  Updates paths in certain config files based on the user's chosen
  installation directory
  """
  # List of files containing absolute paths from the build machine
  files = [
    'bin/erl.ini'
  ]
  full_files = [os.path.join(install_dir, fname) for fname in files]
  path_regex = re.compile(r"C:/Jenkins/workspace/.*windows/install")
  backslash_regex = re.compile(r"\\")

  # Replace build-machine install path with target installation dir
  for line in fileinput.input(full_files, inplace=1):
    line = path_regex.sub(install_dir, line)
    print backslash_regex.sub("/", line),

  # Finally, copy erl.ini into the erts dist directory as well
  shutil.copy(os.path.join(install_dir, "bin", "erl.ini"),
    os.path.join(install_dir, "erts-5.10.4.0.0.1", "bin"))

def do_createregisterscript(install_dir, extra):
  """
  Configures the service_register.bat script from .tmpl file
  """
  scriptpath = os.path.join(install_dir, "bin", "service_register.bat")
  if extra[0] == "true":
    vars = {
      "LOCALHOST": "::1",
      "IPPROTO": "inet6_tcp",
      "NSIPV6": "true"
    }
  else:
    vars = {
      "LOCALHOST": "127.0.0.1",
      "IPPROTO": "inet_tcp",
      "NSIPV6": "false"
    }

  with open(scriptpath + ".tmpl") as tmplfile:
    tmpl = Template(tmplfile.read())
  with open(scriptpath, "w") as scriptfile:
    scriptfile.write(tmpl.substitute(vars))

def do_wait_for_server(install_dir, _):
  """
  Waits for localhost:8091 to start responding, up to 15 seconds
  """
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  for i in range(15):
    try:
      s.connect(("127.0.0.1", 8091))
      break
    except socket.error:
      print("Got an error")
      time.sleep(.8)

if __name__ == "__main__":
  functions = {
      "backup-var": do_backup_var,
      "fixpaths": do_fixpaths,
      "createregisterscript": do_createregisterscript,
      "wait-for-server": do_wait_for_server
  }
  parser = argparse.ArgumentParser()
  parser.add_argument('install_dir', type=str)
  parser.add_argument('operation', type=str)
  parser.add_argument('extra', nargs=argparse.REMAINDER)
  args = parser.parse_args()
  # Couchbase.wxs passes the install_dir argument with an extra \FOO at the end,
  # because [INSTALLDIR] in Wix has a trailing \ and there's no way to quote that
  # without the command interpreter treating that as an escaped quote. :P
  install_dir = args.install_dir[:-4]
  operation = args.operation
  functions[operation](install_dir, args.extra)
