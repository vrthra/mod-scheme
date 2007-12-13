#Script for interpreting the template into c file
#ReturnType    pointer0|int1  lib_name function_name arg_type pointer|int 
#my %funct = (
#        r_data  => "",
#        r_type => 0,
#        lib_name => "apr",
#        funct_name => "funct",
#        arg_list => "ref",
#);

$g_module = shift;
$g_output_dir = shift;

sub populate {
    my $line = shift;
    my @parts = split /,/ ,$line;
    my @rtype = (shift(@parts),shift(@parts));
    my $lib = shift(@parts);
    my $struct = shift @parts;
    my $member = shift @parts;
    my %struct = (
        r_data => \@rtype,
        lib => $lib,
        struct => $struct,
        member => $member
    );
    return %struct;
}    
sub make_data1 {
    my $lib = shift;
    my $struct = shift;
    my $member = shift;
    my $strdata = <<STR;
pointer get_%s_%s(scheme *sc, pointer args) { 
    pointer data; 
    %s * struct_type; 
      TRACE("%s"); 
    if (args != sc->NIL) { 
       data = pair_car(args); 
       if (data == sc->NIL) { 
             scheme_exception(sc, "%s [no args]" ); 
             return sc->NIL; 
         }
           struct_type = (%s *)ptr_value(data); 
       return mk_pointer(sc,(ptrval)(struct_type->%s)); 
    } 
    scheme_exception(sc,"%s [no args]"); 
    return sc->NIL; 
}

STR
    my $expstr = $lib.":".$struct."->".$member;
    my $result = sprintf($strdata, ( lc($struct), lc($member), $struct, $expstr, $expstr, $struct, $member, $expstr));
}

sub make_data2 {
    my $lib = shift;
    my $struct = shift;
    my $member = shift;
    my $strdata = <<STR;
pointer get_%s_%s(scheme *sc, pointer args) { 
    pointer data; 
    %s * struct_type; 
      TRACE("%s"); 
    if (args != sc->NIL) { 
       data = pair_car(args); 
       if (data == sc->NIL) { 
             scheme_exception(sc, "%s [no args]" ); 
             return sc->NIL; 
         }
           struct_type = (%s *)ptr_value(data); 
       return mk_integer(sc,(long)(struct_type->%s)); 
    } 
    scheme_exception(sc,"%s [no args]"); 
    return sc->NIL; 
}

STR
    my $expstr = $lib.":".$struct."->".$member;
    my $result = sprintf($strdata, ( lc($struct), lc($member), $struct, $expstr, $expstr, $struct, $member, $expstr));
}

sub make_data_doc {
    my $lib = shift;
    my $struct = shift;
    my $member = shift;
    my $rettype = shift;
    my $strdata = <<STR;
<tr><td><a href='http://lxr.webperf.org/ident.cgi?i=%s'>%s</a></td><td>%s</td><td>%s</td></tr>
STR
    my $expstr = $lib.":".$struct."->".$member;
    my $result = sprintf($strdata, (
            lc($struct),
            lc($struct).".". lc($member),
            $expstr,
            $rettype));
}


sub use_data_doc {
    my $data = shift;
    my $lib = $data->{lib};
    $lib =~ s/[ \t\n]+//g;
    my $struct = $data->{struct};
    $struct =~ s/[ \t\n]+//g;
    my $ret = $data->{r_data};
    my $member = $data->{member};
    $member =~ s/[ \t\n]+//g;
    my $typecast = $ret->[0];
    $typecast =~s/^\^\^_(.+)$/$1 \*\* /g;
    $typecast =~s/^\^_(.+)$/$1 \* /g;
    return &make_data_doc($lib,$struct,$member,$typecast);

}

sub use_data {
    my $data = shift;
    my $lib = $data->{lib};
    $lib =~ s/[ \t\n]+//g;
    my $struct = $data->{struct};
    $struct =~ s/[ \t\n]+//g;
    my $ret = $data->{r_data};
    my $member = $data->{member};
    $member =~ s/[ \t\n]+//g;

    my $mk_val = "error";
    my $cast = "error";
    my $result ="";
    if ($ret->[1] == 0) {
        $result = &make_data1($lib,$struct,$member);
    } else {
        $result = &make_data2($lib,$struct,$member);

    }
    return $result;

}

sub make_data_decl {
    my $lib = shift;
    my $struct = shift;
    my $member = shift;
    my $strdata = <<STR;
    scheme_define(sc,sc->global_env, 
    mk_symbol(sc,"%s:%s->%s"), 
    mk_foreign_func(sc,get_%s_%s));

STR
    my $result = sprintf($strdata, ( lc($lib), lc($struct), lc($member), lc($struct), lc($member)));
}

sub use_data_decl {
    my $data = shift;
    my $lib = $data->{lib};
    $lib =~ s/[ \t\n]+//g;
    my $struct = $data->{struct};
    $struct =~ s/[ \t\n]+//g;
    my $ret = $data->{r_data};
    my $member = $data->{member};
    $member =~ s/[ \t\n]+//g;
    return &make_data_decl($lib,$struct,$member);
}


sub print_header {
    $file = shift;
    $name = shift;
    print $file "<tr><td><b>$name</b></td><td></td><td></td><td></td></tr>\n";
}




sub main {
    my $optarg = shift @ARGV;
    my @files = <./${g_output_dir}/*.stpl>;
    if ( $optarg eq "-doc" ) {
        open(OF,">${g_output_dir}/${g_module}_scheme_structs.html") or die "cannot open ${g_module}_scheme_structs.html\n"; 
        print OF "<html><body><table border=1><tr><td>Apache Struct Member</td><td>Scheme Name</td><td>Type</td></tr>";
    }
    for my $file (@files) {
        open(IF,$file) or die "cannot read $file for converting\n"; 
        if ($optarg eq "-dec") {
            open(OF,">".$file.".o.c") or die "cannot read $file.i for converting\n"; 
        } elsif($optarg eq "-def") {
            open(OF,">".$file.".i.c") or die "cannot read $file.i for converting\n"; 
        }

        if ($optarg eq "-doc") {
            $file =~ /.*scheme_(.*)[.]+stpl/;
            &print_header(OF,"<a href='http://lxr.webperf.org/source.cgi/include/${1}.h'>".$1.".h</a>");
        }

        my @tplfile = grep {!/(^#)|(^[ \t]*$)|(^$)/} <IF>; #Later we can change these comments to c comments and include it.
        @tplfile = grep {!/^[\x]*$/} @tplfile;
        my @outdata = ();
        for my $line (@tplfile) {
            chomp $line;
            %f_struct = &populate($line);
            if ($optarg eq "-dec") {
                $outdata[++$#outdata] = &use_data_decl(\%f_struct);
            } elsif($optarg eq "-def") {
                $outdata[++$#outdata] = &use_data(\%f_struct);
            } elsif($optarg eq "-doc") {
                $outdata[++$#outdata] = &use_data_doc(\%f_struct);
            }
        }
        print OF  @outdata;
        if ( not ( $optarg eq "-doc" ) ) {
            close OF;
        }
    }
    if ($optarg eq "-doc") {
        print OF "</table></body></html>";
        close OF;
    }
}
&main;
