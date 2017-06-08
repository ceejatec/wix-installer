set destdir500=%~dp0\testing-5.0.0
set destdir501=%~dp0\testing-5.0.1

rmdir /s /q build
rmdir /s /q dist
python fixpaths-setup.py py2exe
python backup-var-setup.py py2exe
rmdir /s /q build
copy dist\* testing-5.0.0\bin\*

heat dir %destdir500% -srd -suid -ag -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 -dVersion=5.0.0 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %destdir500% -dWixUILicenseRtf=..\CouchbaseEnterpriseLicense.rtf -o 500.msi *.wixobj || goto :error

del *.wixobj
copy Files.wxs Files.bak

copy dist\* testing-5.0.1\bin\*

heat dir %destdir501% -srd -suid -ag -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 -dVersion=5.0.1 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %destdir501% -dWixUILicenseRtf=..\CouchbaseEnterpriseLicense.rtf -o 501.msi *.wixobj || goto :error

:end
exit /b 0

:error
@echo Previous command failed with error #%errorlevel%.
exit /b %errorlevel%

