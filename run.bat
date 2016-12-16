copy fixpaths.cmd C:\newbits\couchbase\install\bin

heat dir C:\newbits\couchbase\install -srd -suid -gg -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs || goto :error
candle -arch x64 *.wxs || goto :error
light -ext WixUIExtension -ext WixUtilExtension -b C:\newbits\couchbase\install -o Server.msi *.wixobj || goto :error

:end
exit /b 0

:error
@echo Previous command failed with error #%errorlevel%.
exit /b %errorlevel%

