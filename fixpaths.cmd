set INSTALLDIR=%~1

"%INSTALLDIR%\bin\fnr.exe" --cl --silent --fileMask static_config --dir "%INSTALLDIR%etc\couchbase" --useRegEx --find "C:/Jenkins/workspace/.*windows/couchbase/install/" --replace "%INSTALLDIR%\"
"%INSTALLDIR%\bin\fnr.exe" --cl --silent --fileMask static_config --dir "%INSTALLDIR%etc\couchbase" --find "\\" --replace "/"