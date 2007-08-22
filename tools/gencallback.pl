#Script for interpreting the template into c file
#ReturnType	pointer0|int1  lib_name function_name arg_type pointer|int 
#my %funct = (
#		r_data  => "",
#		r_type => 0,
#		lib_name => "apr",
#		funct_name => "funct",
#		arg_list => "ref",
#);
#
$g_module = shift;
$g_output_dir = shift;
sub arg_arr {
		my $tarr = shift;
		my @arr =  @$tarr;
		my @arrdata = ();
		for ($i = 0; $i < $#arr; $i = $i + 2) {
				my @data = ($arr[$i],$arr[$i+1]);
				$arrdata[++$#arrdata] = \@data;
		}
		return @arrdata;
}
sub real_name {
		my $val = shift;
		my $check = shift;
		if ($check == 0) {
				return $val;
		} else {
				return uc($val); 
		}

}


sub populate {
		my $line = shift;
		my @parts = split /,/ ,$line;
		my $macro = shift @parts;
		my @rtype = (shift(@parts),shift(@parts));
		my $lib = shift(@parts);
		my $funct = shift @parts;
		my @argarr = &arg_arr (\@parts);
		my %funct = (
				macro => $macro,
				r_data => \@rtype,
				lib => $lib,
				funct => $funct,
				arg => \@argarr
		);
		return %funct;
}	

sub get_decl {
	my $argarr = shift;
	my $delim = "";
	my $decl = "";
	my $count = 0;
	foreach $argpart (@$argarr) {
		my $varcast = $argpart->[0];
		$varcast =~s/\^/P/g;
		$decl =  $decl.$delim.$varcast."_var_".$count;
		$decl =~ s/[ \t]*//g;
		$delim = ",";
		$count++;
	}
	if ($count == 0) {
			return "";
	}
	return "pointer ".$decl." ;";
}

sub get_argval {
	my $argarr = shift;
	my $str = shift;
	my $delim = "";
	my $decl = "";
	my $count = 0;
	foreach $argpart (@$argarr) {
		my $varcast = $argpart->[0];
		$varcast =~s/[ \t\n]+//g;
		$varcast =~s/\^/P/g;
		$decl =  $decl.$delim."\n						ARG_ASSERT(".$varcast."_var_".$count.",tempargs,\"".$str."[no arg(".$varcast.")]\")";
		$delim = "\n						tempargs = pair_cdr(tempargs);";
		$count++;
	}
	return $decl;
}
sub get_convarg {
	my $argarr = shift;
	my $delim = "";
	my $decl = "";
	my $val_type = "";
	my $count = 0;
	foreach $argpart (@$argarr) {
		my $typecast = $argpart->[0];
		#$typecast =~s/[ \t\n]+//g;
		$typecast =~ s/^([\^ \t]+)_(.+)$/ $2 $1 /g;
		$typecast =~ s/\^/*/g;
		my $varcast = $argpart->[0];
		$varcast  =~s/\^/P/g;
		$varcast =~s/[ \t\n]+//g;

		if (	$argpart->[1] == 0 ) {
				$val_type = "ptr_value";
		} elsif ( $argpart->[1] == 1 ) {
				$val_type = "ivalue";
		}
		$decl =  $decl.$delim."(".$typecast.")".$val_type."(".$varcast."_var_".$count.")" ;
		$count++;
		$delim = ",";
	}
	return $decl;
}
sub get_convarg_doc {
	my $argarr = shift;
	my $delim = "";
	my $decl = "";
	my $val_type = "";
	my $count = 0;
	foreach $argpart (@$argarr) {
#		$argpart->[0] =~s/[ \t\n]+//g;
		my $typecast = $argpart->[0];
		$typecast =~s/[ \t\n]+//g;
		$typecast =~s/^\^\^_(.+)$/$1 \*\* /g;
		$typecast =~s/^\^_(.+)$/$1 \* /g;

		$decl =  $decl.$delim.$typecast;
		$count++;
		$delim = ",";
	}
	return $decl;
}
sub use_data_doc {
		my $data = shift;
		my $lib = $data->{lib};
		$lib =~ s/[ \t\n]+//g;
		my $funct = $data->{funct};
		$funct =~ s/[ \t\n]+//g;
		my $ret = $data->{r_data};
		my $vars = $data->{arg};
		my $decl = &get_decl($vars);
		my $argval = &get_argval($vars,$lib.":".$funct);
		my $convarg = &get_convarg_doc($vars);
#APIName
#Available in scheme as
#Return Type
#Params
		my $strdata1 = <<STR;
<tr><td><a href='http://lxr.webperf.org/ident.cgi?i=%s'>%s</a></td><td>%s</td><td>%s</td><td>%s</td></tr>
STR

		my $mk_val = "error";
		my $cast = "error";
		my $result ="";
		if ($ret->[1] == 0) {
				$mk_val = "mk_pointer";
				$cast = "ptrval";
		} elsif($ret->[1] == 1) {
				$mk_val = "mk_integer";
				$cast = "long"; 
		}
		$ret->[0]  =~s/[ \t\n]+//g;
		my $typecast = $ret->[0];
		$typecast =~s/^\^\^_(.+)$/$1 \*\* /g;
		$typecast =~s/^\^_(.+)$/$1 \* /g;
		if ($ret->[0] eq "bool") {
				$result = sprintf($strdata1,( 
#APIName				
				real_name( $lib,$data->{macro} )."_".real_name($funct,$data->{macro}),
				real_name( $lib,$data->{macro} )."_".real_name($funct,$data->{macro}),
#Available in scheme as				
				lc($lib).":".lc($funct),
#Return Type				
				"bool",
#Params
				$convarg));
		
		} elsif($ret->[0] eq "void")  {
				$result = sprintf($strdata1,( 
#APIName				
				real_name( $lib,$data->{macro} )."_".real_name($funct,$data->{macro}),
				real_name( $lib,$data->{macro} )."_".real_name($funct,$data->{macro}),
#Available in scheme as				
				lc($lib).":".lc($funct),
#Return Type				
				"void",
#Params
				$convarg));
		
		} else {
				$result = sprintf($strdata1,( 
#APIName				
				real_name( $lib,$data->{macro} )."_".real_name($funct,$data->{macro}),
				real_name( $lib,$data->{macro} )."_".real_name($funct,$data->{macro}),
#Available in scheme as				
				lc($lib).":".lc($funct),
#Return Type				
				$typecast,
#Params
				$convarg));
		}
		return $result;

}

sub use_data {
		my $data = shift;
		my $lib = $data->{lib};
		$lib =~ s/[ \t\n]+//g;
		my $funct = $data->{funct};
		$funct =~ s/[ \t\n]+//g;
		my $ret = $data->{r_data};
		my $vars = $data->{arg};
		my $decl = &get_decl($vars);
		my $argval = &get_argval($vars,$lib.":".$funct);
		my $convarg = &get_convarg($vars);
		my $strdata1 = <<STR;
		pointer scheme_%s_%s(scheme *sc, pointer args) { 
				%s
				%s f_ret; 
				pointer tempargs; 
				TRACE("%s:%s"); 
				if (args != sc->NIL) { 
						tempargs = args; 
						%s
						f_ret = %s_%s( %s); 
						return %s(sc,(%s)f_ret); 
				} 
				scheme_exception(sc,"%s:%s [no args]"); 
				return sc->NIL; 
		}
STR
		my $strdata2 = <<STR;
		pointer scheme_%s_%s(scheme *sc, pointer args) { 
				%s
				pointer tempargs; 
				TRACE("%s:%s"); 
				if (args != sc->NIL) { 
						tempargs = args; 
						%s
						%s_%s( %s); 
						return sc->T; 
				} 
				scheme_exception(sc,"%s:%s [no args]"); 
				return sc->NIL; 
		}
STR
		my $strdata3 = <<STR;
		pointer scheme_%s_%s(scheme *sc, pointer args) { 
				%s
				pointer tempargs; 
				TRACE("%s:%s"); 
				if (args != sc->NIL) { 
						tempargs = args; 
						%s
						if(%s_%s( %s)) return sc->T;
						else return sc->F; 
				} 
				scheme_exception(sc,"%s:%s [no args]"); 
				return sc->NIL; 
		}
STR



		my $mk_val = "error";
		my $cast = "error";
		my $result ="";
		if ($ret->[1] == 0) {
				$mk_val = "mk_pointer";
				$cast = "ptrval";
		} elsif($ret->[1] == 1) {
				$mk_val = "mk_integer";
				$cast = "long"; 
		}
		$ret->[0]  =~s/[ \t\n]+//g;
		my $typecast = $ret->[0];
		$typecast =~s/^\^\^_(.+)$/$1 \*\* /g;
		$typecast =~s/^\^_(.+)$/$1 \* /g;
		if ($ret->[0] eq "bool") {
				$result = sprintf($strdata3,( lc($lib),lc($funct),$decl,lc($lib),lc($funct),$argval,
								real_name( $lib,$data->{macro} ),real_name($funct,$data->{macro}),
								$convarg,lc($lib),lc($funct)));			
		} elsif($ret->[0] eq "void")  {
				$result = sprintf($strdata2,( lc($lib),lc($funct),$decl,lc($lib),lc($funct),$argval,
								real_name( $lib,$data->{macro} ),real_name($funct,$data->{macro}),
								$convarg,lc($lib),lc($funct)));
		} else {
				$result = sprintf($strdata1,( lc($lib),lc($funct),$decl,$typecast,lc($lib),lc($funct),$argval,
								real_name( $lib,$data->{macro} ),real_name($funct,$data->{macro}),
								$convarg,$mk_val,$cast,lc($lib),lc($funct)));

		}
		return $result;

}

sub make_data_decl {
		my $lib = shift;
		my $funct = shift;
		my $strdata = <<STR;
	scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"%s:%s"), 
    mk_foreign_func(sc,scheme_%s_%s));

STR
		my $result = sprintf($strdata, ( lc($lib), lc($funct), lc($lib), lc($funct)));
}

sub use_data_decl {
		my $data = shift;
		my $lib = $data->{lib};
		$lib =~ s/[ \t\n]+//g;
		my $funct = $data->{funct};
		$funct =~ s/[ \t\n]+//g;
		return &make_data_decl($lib,$funct);
}

sub print_header {
    $file = shift;
    $name = shift;
    print $file "<tr><td><b>$name</b></td><td></td><td></td><td></td></tr>\n";
}


sub main {
		my $optarg = shift @ARGV;
		my @files = <./${g_output_dir}/*.tpl>;

        if ( $optarg eq "-doc" ) {
            open(OF,">${g_output_dir}/${g_module}_scheme_api.html") or die "cannot open ${g_module}_scheme_api.html\n"; 
            print OF "<html><body><table border=1><tr><td>Apache API</td><td>Scheme API</td><td>Return Type</td><td>Arguments</td></tr>\n";
        }

		for my $file (@files) {
				open(IF,$file) or die "cannot read $file for converting\n"; 
				if ($optarg eq "-dec") {
						open(OF,">".$file.".o.c") or die "cannot read $file.i for converting\n"; 
				} elsif($optarg eq "-def") {
						open(OF,">".$file.".i.c") or die "cannot read $file.i for converting\n"; 
				}

				my @tplfile = grep {!/^#/} <IF>; #Later we can change these comments to c comments and include it.
				my @outdata = ();
                if ($optarg eq "-doc") {
                    $file =~ /.*scheme_(.*)[.]+tpl/;
                    &print_header(OF,"<a href='http://lxr.webperf.org/source.cgi/include/${1}.h'>".$1.".h</a>");
                }
				for my $line (@tplfile) {
						%f_struct = &populate($line);
						if ($optarg eq "-dec") {
								$outdata[++$#outdata] = &use_data_decl(\%f_struct);
						}elsif($optarg eq "-def") {
								$outdata[++$#outdata] = &use_data(\%f_struct);
						}elsif($optarg eq "-doc") {
								$outdata[++$#outdata] = &use_data_doc(\%f_struct);
						}
				}
				print OF @outdata;
                if ( not ( $optarg eq "-doc" ) ) {
                    close OF;
                }
		}
        if ($optarg eq "-doc") {
            print OF "</table></body></html>";
        }
        if ( $optarg eq "-doc" ) {
            close OF;
        }
}
&main;
