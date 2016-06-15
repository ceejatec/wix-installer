set INSTALLDIR=%~1

"%INSTALLDIR%\bin\fnr.exe" --cl --silent --fileMask static_config --dir "%INSTALLDIR%etc\couchbase" --find "C:/Jenkins/workspace/couchbase-server-windows/install/" --replace "%INSTALLDIR%\"
"%INSTALLDIR%\bin\fnr.exe" --cl --silent --fileMask static_config --dir "%INSTALLDIR%etc\couchbase" --find "\\" --replace "/"