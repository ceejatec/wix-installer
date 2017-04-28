set destdir=%~dp0\testing

copy fixpaths.cmd %destdir%\bin
copy fnr.exe %destdir%\bin
copy ..\CouchbaseEnterpriseLicense.rtf %destdir%

heat dir %destdir% -srd -suid -gg -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %destdir% -dWixUILicenseRtf=..\CouchbaseEnterpriseLicense.rtf -o Server.msi *.wixobj || goto :error

:end
exit /b 0

:error
@echo Previous command failed with error #%errorlevel%.
exit /b %errorlevel%

