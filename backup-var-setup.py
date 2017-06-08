from distutils.core import setup
import py2exe

setup(
    windows=["backup-var.py"],
    options={"py2exe": {"bundle_files": 3}},
    zipfile=None
)
