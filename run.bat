set srcpath=C:\bits\couchbase\install

copy fixpaths.cmd %srcpath%\bin
copy fnr.exe %srcpath%\bin
copy CouchbaseEnterpriseLicense.rtf %srcpath

heat dir %srcpath% -srd -suid -gg -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %srcpath% -dWixUILicenseRtf=CouchbaseEnterpriseLicense.rtf -o Server.msi *.wixobj || goto :error

:end
exit /b 0

:error
@echo Previous command failed with error #%errorlevel%.
exit /b %errorlevel%

