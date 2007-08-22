# Microsoft Developer Studio Generated NMAKE File, Based on mod_scheme.dsp
!IF "$(CFG)" == ""
CFG=mod_scheme - Win32 Release
!MESSAGE No configuration specified. Defaulting to mod_scheme - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "mod_scheme - Win32 Release" && "$(CFG)" != "mod_scheme - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
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
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "mod_scheme - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\mod_scheme.so"

!ELSE 

ALL : "libhttpd - Win32 Release" "libaprutil - Win32 Release" "libapr - Win32 Release" "$(OUTDIR)\mod_scheme.so"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libapr - Win32 ReleaseCLEAN" "libaprutil - Win32 ReleaseCLEAN" "libhttpd - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\mod_scheme.obj"
	-@erase "$(INTDIR)\mod_scheme.res"
	-@erase "$(INTDIR)\mod_scheme_src.idb"
	-@erase "$(INTDIR)\mod_scheme_src.pdb"
	-@erase "$(OUTDIR)\mod_scheme.exp"
	-@erase "$(OUTDIR)\mod_scheme.lib"
	-@erase "$(OUTDIR)\mod_scheme.pdb"
	-@erase "$(OUTDIR)\mod_scheme.so"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Zi /O2 /I "../../include" /I "../../srclib/apr/include" /I "../../srclib/apr-util/include" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\mod_scheme_src" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\mod_scheme.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mod_scheme.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib /nologo /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\mod_scheme.pdb" /debug /machine:I386 /out:"$(OUTDIR)\mod_scheme.so" /implib:"$(OUTDIR)\mod_scheme.lib" /base:@..\..\os\win32\BaseAddr.ref,mod_scheme.so /opt:ref 
LINK32_OBJS= \
	"$(INTDIR)\mod_scheme.obj" \
	"$(INTDIR)\mod_scheme.res" \
	"..\..\srclib\apr\Release\libapr.lib" \
	"..\..\srclib\apr-util\Release\libaprutil.lib" \
	"..\..\Release\libhttpd.lib"

"$(OUTDIR)\mod_scheme.so" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "mod_scheme - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\mod_scheme.so"

!ELSE 

ALL : "libhttpd - Win32 Debug" "libaprutil - Win32 Debug" "libapr - Win32 Debug" "$(OUTDIR)\mod_scheme.so"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libapr - Win32 DebugCLEAN" "libaprutil - Win32 DebugCLEAN" "libhttpd - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\mod_scheme.obj"
	-@erase "$(INTDIR)\mod_scheme.res"
	-@erase "$(INTDIR)\mod_scheme_src.idb"
	-@erase "$(INTDIR)\mod_scheme_src.pdb"
	-@erase "$(OUTDIR)\mod_scheme.exp"
	-@erase "$(OUTDIR)\mod_scheme.lib"
	-@erase "$(OUTDIR)\mod_scheme.pdb"
	-@erase "$(OUTDIR)\mod_scheme.so"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /GX /Zi /Od /I "../../include" /I "../../srclib/apr/include" /I "../../srclib/apr-util/include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\mod_scheme_src" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\mod_scheme.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mod_scheme.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib /nologo /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\mod_scheme.pdb" /debug /machine:I386 /out:"$(OUTDIR)\mod_scheme.so" /implib:"$(OUTDIR)\mod_scheme.lib" /base:@..\..\os\win32\BaseAddr.ref,mod_scheme.so 
LINK32_OBJS= \
	"$(INTDIR)\mod_scheme.obj" \
	"$(INTDIR)\mod_scheme.res" \
	"..\..\srclib\apr\Debug\libapr.lib" \
	"..\..\srclib\apr-util\Debug\libaprutil.lib" \
	"..\..\Debug\libhttpd.lib"

"$(OUTDIR)\mod_scheme.so" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("mod_scheme.dep")
!INCLUDE "mod_scheme.dep"
!ELSE 
!MESSAGE Warning: cannot find "mod_scheme.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "mod_scheme - Win32 Release" || "$(CFG)" == "mod_scheme - Win32 Debug"

!IF  "$(CFG)" == "mod_scheme - Win32 Release"

"libapr - Win32 Release" : 
   cd ".\..\..\srclib\apr"
   $(MAKE) /$(MAKEFLAGS) /F ".\libapr.mak" CFG="libapr - Win32 Release" 
   cd "..\..\modules\scheme"

"libapr - Win32 ReleaseCLEAN" : 
   cd ".\..\..\srclib\apr"
   $(MAKE) /$(MAKEFLAGS) /F ".\libapr.mak" CFG="libapr - Win32 Release" RECURSE=1 CLEAN 
   cd "..\..\modules\scheme"

!ELSEIF  "$(CFG)" == "mod_scheme - Win32 Debug"

"libapr - Win32 Debug" : 
   cd ".\..\..\srclib\apr"
   $(MAKE) /$(MAKEFLAGS) /F ".\libapr.mak" CFG="libapr - Win32 Debug" 
   cd "..\..\modules\scheme"

"libapr - Win32 DebugCLEAN" : 
   cd ".\..\..\srclib\apr"
   $(MAKE) /$(MAKEFLAGS) /F ".\libapr.mak" CFG="libapr - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\..\modules\scheme"

!ENDIF 

!IF  "$(CFG)" == "mod_scheme - Win32 Release"

"libaprutil - Win32 Release" : 
   cd ".\..\..\srclib\apr-util"
   $(MAKE) /$(MAKEFLAGS) /F ".\libaprutil.mak" CFG="libaprutil - Win32 Release" 
   cd "..\..\modules\scheme"

"libaprutil - Win32 ReleaseCLEAN" : 
   cd ".\..\..\srclib\apr-util"
   $(MAKE) /$(MAKEFLAGS) /F ".\libaprutil.mak" CFG="libaprutil - Win32 Release" RECURSE=1 CLEAN 
   cd "..\..\modules\scheme"

!ELSEIF  "$(CFG)" == "mod_scheme - Win32 Debug"

"libaprutil - Win32 Debug" : 
   cd ".\..\..\srclib\apr-util"
   $(MAKE) /$(MAKEFLAGS) /F ".\libaprutil.mak" CFG="libaprutil - Win32 Debug" 
   cd "..\..\modules\scheme"

"libaprutil - Win32 DebugCLEAN" : 
   cd ".\..\..\srclib\apr-util"
   $(MAKE) /$(MAKEFLAGS) /F ".\libaprutil.mak" CFG="libaprutil - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\..\modules\scheme"

!ENDIF 

!IF  "$(CFG)" == "mod_scheme - Win32 Release"

"libhttpd - Win32 Release" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\libhttpd.mak" CFG="libhttpd - Win32 Release" 
   cd ".\modules\scheme"

"libhttpd - Win32 ReleaseCLEAN" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\libhttpd.mak" CFG="libhttpd - Win32 Release" RECURSE=1 CLEAN 
   cd ".\modules\scheme"

!ELSEIF  "$(CFG)" == "mod_scheme - Win32 Debug"

"libhttpd - Win32 Debug" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\libhttpd.mak" CFG="libhttpd - Win32 Debug" 
   cd ".\modules\scheme"

"libhttpd - Win32 DebugCLEAN" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\libhttpd.mak" CFG="libhttpd - Win32 Debug" RECURSE=1 CLEAN 
   cd ".\modules\scheme"

!ENDIF 

SOURCE=.\mod_scheme.c

"$(INTDIR)\mod_scheme.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\mod_scheme.rc

"$(INTDIR)\mod_scheme.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=..\..\build\win32\win32ver.awk

!IF  "$(CFG)" == "mod_scheme - Win32 Release"

InputPath=..\..\build\win32\win32ver.awk

".\mod_scheme.rc" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@scheme off 
	awk -f ../../build/win32/win32ver.awk mod_scheme.so "scheme_module for Apache" ../../include/ap_release.h > .\mod_scheme.rc
<< 
	

!ELSEIF  "$(CFG)" == "mod_scheme - Win32 Debug"

InputPath=..\..\build\win32\win32ver.awk

".\mod_scheme.rc" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@scheme off 
	awk -f ../../build/win32/win32ver.awk mod_scheme.so "scheme_module for Apache" ../../include/ap_release.h > .\mod_scheme.rc
<< 
	

!ENDIF 


!ENDIF 

