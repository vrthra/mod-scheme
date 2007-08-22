@echo off
REM For win32 alone
REM Does apache header parsing and creating the mod_scheme includes.
@echo on
cd apache
perl ..\tools\parseh.pl %1%
perl ..\tools\sparseh.pl %1%
perl ..\tools\gencallback.pl gen -def
perl ..\tools\gencallback.pl gen -dec
perl ..\tools\gencallback.pl gen  -doc
perl ..\tools\genstruct.pl gen -def
perl ..\tools\genstruct.pl gen -dec
perl ..\tools\genstruct.pl gen -doc
perl ..\tools\generate_tie.pl gen %1%
cd auxiliary
perl ..\..\tools\gencallback.pl . -def
perl ..\..\tools\gencallback.pl . -dec
perl ..\..\tools\gencallback.pl . -doc
perl ..\..\tools\genstruct.pl . -def
perl ..\..\tools\genstruct.pl . -dec
perl ..\..\tools\genstruct.pl . -doc
cd ..\..
