copy fixpaths.cmd C:\bits\couchbase\install\bin

heat dir C:\bits\couchbase\install -srd -suid -gg -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs
candle -arch x64 *.wxs
light -ext WixUIExtension -ext WixUtilExtension -b C:\bits\couchbase\install -o Server.msi *.wixobj
