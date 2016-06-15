heat dir C:\newbits -srd -suid -gg -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs
candle -arch x64 *.wxs
light -ext WixUIExtension -ext WixUtilExtension -b C:\newbits -o Server.msi *.wixobj
