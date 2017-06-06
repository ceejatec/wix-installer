set destdir500=%~dp0\testing-5.0.0
set destdir501=%~dp0\testing-5.0.1

copy fixpaths.cmd %destdir500%\bin
copy fnr.exe %destdir500%\bin

heat dir %destdir500% -srd -suid -ag -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 -dVersion=5.0.0 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %destdir500% -dWixUILicenseRtf=..\CouchbaseEnterpriseLicense.rtf -o 500.msi *.wixobj || goto :error

del *.wixobj
copy Files.wxs Files.bak

copy fixpaths.cmd %destdir501%\bin
copy fnr.exe %destdir501%\bin

heat dir %destdir501% -srd -suid -ag -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 -dVersion=5.0.1 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %destdir501% -dWixUILicenseRtf=..\CouchbaseEnterpriseLicense.rtf -o 501.msi *.wixobj || goto :error

:end
exit /b 0

:error
@echo Previous command failed with error #%errorlevel%.
exit /b %errorlevel%

