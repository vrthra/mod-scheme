#creates the scheme_*.c and scheme_*.h files
#$apache_inc_dir = "C:/work/servers/Apache/2.0.50/Apache2/include";
$g_output_dir = shift @ARGV;
$apache_inc_dir = shift @ARGV;

{
		my @exclude_header;

		sub init_exclusion {
				open EXCLUDE , "<headers.exclude" or die "cant open headers.exclude";
				@exclude_header = <EXCLUDE>;
				close EXCLUDE;
		}

		sub exclude_header {
				my $file = shift;
				foreach (@exclude_header) {
						chomp;
						return 1 if $file =~ $_;
				}
				return 0;
		}
}
sub gen_src_and_headers {
		my $c_src = <<CSRC;
/**
* %s
* Generated file , do not edit by hand.
*/
#include "%s.h"
///* now included in apache_symbols.c
#include "apache/macros.h"
#include "scheme-private.h"
#include "apache/ptr_types.h"
#include "callback.h"
//*/
#ifdef _defined_scheme_%s_aux
#include "apache/auxiliary/scheme_%s_aux.c"
#endif

//auto structs
#include "./scheme_%s.stpl.i.c"

//auto functs
#include "./scheme_%s.tpl.i.c"

void load_scheme_%s_symbols(scheme *sc) {

#ifdef _defined_scheme_%s_aux
	load_scheme_%s_symbols_aux(sc);
#endif

//auto structs
#include "./scheme_%s.stpl.o.c"
//auto functs
#include "./scheme_%s.tpl.o.c"
}

/*
#ifdef _defined_scheme_%s_aux
#include "apache/auxiliary/scheme_%s_aux.c"
#endif
*/
CSRC

		my $h_src = <<HSRC;
#ifndef SCHEME_%s_H
	#define SCHEME_%s_H
void load_scheme_%s_symbols(scheme *sc);
#endif
HSRC

		#Read the exclusion header entries.
		&init_exclusion();
		foreach $file (<${apache_inc_dir}/*.h>) {
				next if exclude_header($file);
				open INFILE , "<$file" or die "cant open $file";
				my $file_name = $file;
				if ($file =~ /.*\/([^.\/]+)[.]+h$/) {
						$file_name = $1;
				}
				open COUTFILE , ">${g_output_dir}/scheme_$file_name.c" or die "cant open scheme_$file_name";
				open HOUTFILE , ">${g_output_dir}/scheme_$file_name.h" or die "cant open scheme_$file_name";
				my $cout = COUTFILE;
				my $hout = HOUTFILE;
				print $cout sprintf ($c_src , ($file_name,$file_name,$file_name,$file_name,$file_name,$file_name,$file_name,
								$file_name,$file_name,$file_name,$file_name,$file_name,$file_name));
				print $hout sprintf ($h_src , ($file_name,$file_name,$file_name));
				close INFILE;
				close COUTFILE;
				close HOUTFILE;
		}
}
#-----------------------------------------------------------------------------------------------------------------------------
#
sub create_inc_apache_symbols {
		my $headers = shift;
		my $src;
		foreach $h (@$headers) {
			$src.= "#include"." \"apache/${g_output_dir}/scheme_".$h.".h\"\n";
		}
		return $src;
}

sub create_src_apache_symbols {
		my $headers = shift;
		my $src;
		foreach $h (@$headers) {
			$src.= "#include"." \"apache/${g_output_dir}/scheme_".$h.".c\"\n";
		}
		return $src;
}


sub create_enum_apache_symbols {
		my $headers = shift;
		my $enum = "enum {\n";
		my $delim = "";
		foreach $h (@$headers) {
				$enum.=$delim."REF_".uc($h);
				$delim = ",\n";
		}
		return $enum."\n};\n";
}

sub create_use_def_apache_symbols {
		my $headers = shift;
		my $src;
		my $body_tmpl = <<END;
pointer use_symbol(scheme *sc, pointer args) {
	int ref_file;
		if (args != sc->NIL) {
			ref_file = int_value(pair_car(args));
		switch (ref_file) {
%s
		default:
			return sc->NIL;
		}
	}
		return sc->NIL;
}
END
		my $line = <<LINE;
	  case REF_%s:
			load_scheme_%s_symbols(sc);
			break;
LINE

		foreach $h (@$headers) {
			$src.= sprintf($line, (uc($h), $h));
		}
		$src = sprintf($body_tmpl,($src));
		return $src;
}

sub create_proto_apache_symbols {
my $src = <<EOF;
#include "scheme.h"
#include "scheme-private.h"
#include "apache/macros.h"
EOF

return $src;
}

sub create_load_sym_apache_symbols {
		my $headers = shift;
		my $src;
		my $tmpl = <<TMPL;
void scheme_load_apache_symbols(scheme *sc){
//env reference
	DEF_SYMBOL("use",use_symbol)

//The symbols used for identifying which symbol-groups to load. used as >> (use apache:util_filter)
%s
}
TMPL
		my $line = <<LINE;
			DEF_CONST("apache:%s",REF_%s)
LINE
		foreach $h (@$headers) {
			$src.= sprintf($line, ($h, uc($h)));
		}
		$src = sprintf($tmpl,($src));
		return $src;
}

sub gen_apache_symbols {
		my @apache_headers;
		foreach $file (<${apache_inc_dir}/*.h>) {
				next if exclude_header($file);
				if ($file =~ /.*\/([^.\/]+)[.]+h$/) {
						$file_name = $1;
				}
				$apache_headers[$#apache_headers +1] = $file_name;
		}

		open APACHEH , ">${g_output_dir}/apache_symbols.c" or die "cant open apache_symbols.c";
		print APACHEH create_proto_apache_symbols();
#		print APACHEH create_inc_apache_symbols(\@apache_headers);
		print APACHEH create_enum_apache_symbols(\@apache_headers);
		print APACHEH create_src_apache_symbols(\@apache_headers);
		print APACHEH create_use_def_apache_symbols(\@apache_headers);
		print APACHEH create_load_sym_apache_symbols(\@apache_headers);
		close APACHEH;
}


sub flow {
		#first create all the scheme_*.c and scheme_*.h files that includes the 
		#stpl.i/o.c and tpl.i/o.c files with in them.
	&gen_src_and_headers;
	&gen_apache_symbols;

}

&flow;
