apachedir=/usr/local/apache2

APXS=${apachedir}/bin/apxs

APACHE_INCLUDE=/usr/local/apache2/include
APR_INCLUDE=/usr/local/include/apr-1

#   the default target
all: gen ts apxs

#   install the shared object file into Apache 
install: install-modules

#   cleanup
clobber:
	-rm -f mod_scheme.o mod_scheme.lo mod_scheme.slo scheme.slo mod_scheme.la \
		scheme.o scheme.lo dynload.o dynload.slo dynload.la callback.o callback.lo callback.slo \
		apache_tie.o apache_symbols.o internal.o
	-rm -f apache/gen/*.*
	-rm -f apache/auxiliary/*.o 
	-rm -f apache_tie.lo apache_symbols.lo internal.lo dynload.lo \
		apache_tie.slo apache_symbols.slo internal.slo 
	-rm -f apache_gen aux_gen
	-rm -f apache/gen/*.tpl.* apache/gen/*.stpl.* apache/gen/*.html
	-rm -f apache/auxiliary/*.stpl.i.c apache/auxiliary/*.stpl.o.c apache/auxiliary/*.tpl.i.c apache/auxiliary/*.tpl.o.c apache/auxiliary/*.html
	-rm -rf .libs
	-rm -f mod_scheme_bin.*
	-rm -f *.loT
	-rm -f tinyscheme


gen: apache_gen aux_gen

apache_gen:
	-rm -rf .deps;touch .deps
	cd apache;perl ../tools/parseh.pl $(APACHE_INCLUDE) $(APR_INCLUDE)
	cd apache;perl ../tools/sparseh.pl $(APACHE_INCLUDE) $(APR_INCLUDE)
	cd apache;perl ../tools/gencallback.pl gen gen -def
	cd apache;perl ../tools/gencallback.pl gen gen -dec
	cd apache;perl ../tools/gencallback.pl gen gen -doc
	cd apache;perl ../tools/genstruct.pl gen gen -def
	cd apache;perl ../tools/genstruct.pl gen gen -dec
	cd apache;perl ../tools/genstruct.pl gen gen -doc
	cd apache;perl ../tools/generate_tie.pl gen $(APACHE_INCLUDE) $(APR_INCLUDE)
	echo > apache_gen

aux_gen:
	cd apache/auxiliary;perl ../../tools/gencallback.pl auxiliary . -def
	cd apache/auxiliary;perl ../../tools/gencallback.pl auxiliary . -dec
	cd apache/auxiliary;perl ../../tools/gencallback.pl auxiliary . -doc
	cd apache/auxiliary;perl ../../tools/genstruct.pl auxiliary . -def
	cd apache/auxiliary;perl ../../tools/genstruct.pl auxiliary . -dec
	cd apache/auxiliary;perl ../../tools/genstruct.pl auxiliary . -doc
	echo > aux_gen

ts:
	rm -rf tinyscheme
	gzcat tinyscheme-1.35.tar.gz | tar -xvpf -
	mv tinyscheme-1.35 tinyscheme
	(cd tinyscheme; patch -u < ../patch.tinyscheme)

apxs:
	${APXS} -c -o mod_scheme.so -I. mod_scheme.c callback.c apache_symbols.c apache_tie.c internal.c tinyscheme/scheme.c tinyscheme/dynload.c

bundle:
	(-rm -rf release; \
		mkdir release; \
		mkdir release/docs; \
		mkdir release/tinyscheme; \
		mkdir release/htdocs; \
		mkdir release/init; \
		mkdir release/conf; \
		mkdir release/dist )
	#cp ./.libs/mod_scheme.so ./release/
	cp ./dist/* ./release/dist
	cp ./apache/gen/*.html ./release/docs/
	cp ./apache/auxiliary/*.html ./release/docs/
	cp hack_mod_scheme.txt ./release/docs/
	cp readme.txt ./release/docs/
	cp install.txt ./release/docs/
	cp mod_scheme-license.txt ./release/docs/
	cp ./tinyscheme/changes ./tinyscheme/copying ./tinyscheme/hack.txt ./tinyscheme/manual.txt \
	./tinyscheme/minischemetribute.txt ./tinyscheme/tinyscheme-license.txt ./tinyscheme/tinyscm.txt ./release/tinyscheme/
	cp ./examples/get.scm ./release/htdocs/
	cp ./examples/post.html ./release/htdocs/
	cp ./examples/*.scm ./release/init/
	cp ./examples/*.conf ./release/conf/
	tar -cf mod_scheme_bin.tar ./release;gzip mod_scheme_bin.tar
	echo "The mod_scheme binary is now available as ./mod_scheme_bin.tar.gz"
