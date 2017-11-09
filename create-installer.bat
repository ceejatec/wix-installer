set destdir500=%~dp0\testing-5.0.0
set destdir501=%~dp0\testing-5.0.1

set productname=%~1
if "%productname%"=="" set productname=Server

rmdir /s /q build
rmdir /s /q dist
python installer-util-setup.py py2exe || goto :error
rmdir /s /q build

pushd testing-5.0.0
git clean -dfx .
popd

heat dir %destdir500% -srd -suid -ag -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
heat dir dist -srd -suid -ag -sreg -ke -cg InstallerUtil -dr BINDIR -out Util.wxs || goto :error
candle -ext WixUtilExtension -arch x64 -dVersion=5.0.0.5759 -dProductName="%productname%" *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %destdir500% -b dist -dWixUILicenseRtf=..\CouchbaseEnterpriseLicense.rtf -o 500.msi *.wixobj || goto :error

exit /b 0

del *.wixobj
copy Files.wxs Files.bak

pushd testing-5.0.1
git clean -dfx .
popd

copy dist\* testing-5.0.1\bin\*

heat dir %destdir501% -srd -suid -ag -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 -dVersion=5.0.1.5759 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b %destdir501% -dWixUILicenseRtf=..\CouchbaseEnterpriseLicense.rtf -o 501.msi *.wixobj || goto :error

:end
exit /b 0

:error
@echo Previous command failed with error #%errorlevel%.
exit /b %errorlevel%

