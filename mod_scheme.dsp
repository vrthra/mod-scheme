# Microsoft Developer Studio Project File - Name="mod_scheme" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=mod_scheme - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "mod_scheme.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mod_scheme.mak" CFG="mod_scheme - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mod_scheme - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_scheme - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "mod_scheme - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MD /W3 /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /FD /c
# ADD CPP /nologo /MD /W3 /Zi /O2 /I "../../include" /I "../../srclib/apr/include" /I "../../srclib/apr-util/include" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /Fd"Release\mod_scheme_src" /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:windows /dll /machine:I386 /out:"Release/mod_scheme.so" /base:@..\..\os\win32\BaseAddr.ref,mod_scheme.so
# ADD LINK32 kernel32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /out:"Release/mod_scheme.so" /base:@..\..\os\win32\BaseAddr.ref,mod_scheme.so /opt:ref

!ELSEIF  "$(CFG)" == "mod_scheme - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /FD /c
# ADD CPP /nologo /MDd /W3 /GX /Zi /Od /I "../../include" /I "../../srclib/apr/include" /I "../../srclib/apr-util/include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /FR /Fd"Debug\mod_scheme_src" /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:windows /dll /incremental:no /debug /machine:I386 /out:"Debug/mod_scheme.so" /base:@..\..\os\win32\BaseAddr.ref,mod_scheme.so
# ADD LINK32 kernel32.lib /nologo /subsystem:windows /dll /incremental:no /debug /machine:I386 /out:"Debug/mod_scheme.so" /base:@..\..\os\win32\BaseAddr.ref,mod_scheme.so

!ENDIF 

# Begin Target

# Name "mod_scheme - Win32 Release"
# Name "mod_scheme - Win32 Debug"
# Begin Group "Header"

# PROP Default_Filter "*.h"
# Begin Source File

SOURCE=.\apache_tie.h
# End Source File
# Begin Source File

SOURCE=.\callback.h
# End Source File
# Begin Source File

SOURCE=.\apache\decl.h
# End Source File
# Begin Source File

SOURCE=.\dynload.h
# End Source File
# Begin Source File

SOURCE=.\internal.h
# End Source File
# Begin Source File

SOURCE=.\apache\macros.h
# End Source File
# Begin Source File

SOURCE=.\mod_scheme.h
# End Source File
# Begin Source File

SOURCE=.\opdefines.h
# End Source File
# Begin Source File

SOURCE=.\apache\ptr_types.h
# End Source File
# Begin Source File

SOURCE=.\resource.h
# End Source File
# Begin Source File

SOURCE=".\scheme-private.h"
# End Source File
# Begin Source File

SOURCE=.\scheme.h
# End Source File
# Begin Source File

SOURCE=.\scheme_code.h
# End Source File
# End Group
# Begin Group "Source"

# PROP Default_Filter "*.c"
# Begin Source File

SOURCE=.\apache_symbols.c
# End Source File
# Begin Source File

SOURCE=.\apache_tie.c
# End Source File
# Begin Source File

SOURCE=.\callback.c
# End Source File
# Begin Source File

SOURCE=.\dynload.c
# End Source File
# Begin Source File

SOURCE=.\internal.c
# End Source File
# Begin Source File

SOURCE=.\mod_scheme.c
# End Source File
# Begin Source File

SOURCE=.\scheme.c
# End Source File
# End Group
# Begin Group "Resource"

# PROP Default_Filter "*.rc"
# Begin Source File

SOURCE=.\mod_scheme.rc
# End Source File
# End Group
# Begin Source File

SOURCE=..\..\build\win32\win32ver.awk
# PROP Ignore_Default_Tool 1
# End Source File
# End Target
# End Project
