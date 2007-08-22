mod_scheme.la: mod_scheme.slo scheme.slo dynload.slo callback.slo apache_symbols.slo apache_tie.slo internal.slo
	$(SH_LINK) -rpath $(libexecdir) -module -avoid-version  mod_scheme.lo scheme.lo dynload.lo callback.lo \
	apache_tie.lo apache_symbols.lo internal.lo

DISTCLEAN_TARGETS = modules.mk
shared =  mod_scheme.la
