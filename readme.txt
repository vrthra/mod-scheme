This distribution contains the scheme module for apache
the following configuration directives are supported.
--httpd.conf--
LoadModule scheme_module modules/mod_scheme.so
InitDirectory "/usr/local/apache2/scheme"
SchemeMaxInterpreters 20
SchemeMinInterpreters 20
AddHandler scheme-handler .scm
SchemeOutputFilter /web/mod_scheme/filterit.scm scm_filter 
AddOutputFilter scm_filter .scm 
SchemeInputFilter /web/mod_scheme/filterit.scm scm_filter 
AddInputFilter scm_filter .scm 
<Location /scheme>
SetHandler scheme-handler
</Location>
--httpd.conf

.34 Changes
    updated to apache 2.0.54 version. [reflects new apis and datastructures in apache 2.0.54]
    cleaned up the parsing code,
    Tested on FreeBSD [5.3], Linux [RHEL-AS 3],Solaris [Sparc 9], Win32 [Win2K]

.30 Changes:
	updated to tinyscheme 1.33
	added output filter. 
	Tested only on OSX

.31 Changes:
	added input filter
	pipe-lining of filters fixed
	most files and directory operations use apr_utils now
	apache apis reflected for use in filters (brigades.) 
	posted data can be read by using http:content
	Tested Only on XP

	To Do:
		better error handling (almost none now)
		better post and get vars (make it into assoc list)
		build a better api for filters using the current reflected apis(may be a stream api like mod_perl)
		move the remaining file and dir ops to apr_utils.
		hook the remaining apis for apache.
		some help for users
		test on more systems

.31a
	Filters now can save their state,
	More APIs

.31b
	More APIs
.31c
	APIs : all structs and functions in these files
	httpd.h
	util_filter
	apr_buckets

.32
	APIs : most apis now generated using the macro.pl from the *.tpl files.
	The integer and pointer handling has been corrected. (no more casting void ptr to int.) with a new
	data type called pointer.
	Refactored the macros and header files
	Better error handling. [writes to log the the exceptional condition correctly]

	To Do:
		Documentation
		A simpler schemy Library on top of this
		This is tested only on win32 systems, correct the make file, build it and test it on unix and the 
		rest of systems
		Hook the remaining apache apis
		Provide some way for saving state and retriving them between requests (comes into picture only after a simpler lib comesup)

.33
	The core is now updated to the new tinyscheme 1.35 version.
	Problems with unix compilation is now fixed.


	Bugs Still pending:
	Though the reflection of APR functions are OK, the example output filter
	that is distributed in the examples directory is broken (It goes into
	an infinete loop after available data is read.)
.33a
	The problem with input_filter is resolved,
	More documentation is added
	
