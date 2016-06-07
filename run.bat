heat dir C:\newbits -srd -gg -sreg -ke -cg CouchbaseServer -dr INSTALLDIR -out Files.wxs
candle -arch x64 *.wxs
light -b C:\newbits -o CouchbaseServer.msi *.wixobj
