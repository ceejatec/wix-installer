from distutils.core import setup
import py2exe

setup(
    windows=["installer-util.py"],
    options={"py2exe": {"bundle_files": 3}},
    zipfile=None
)
