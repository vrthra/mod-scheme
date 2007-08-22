sub eval_file {
		my $lines = shift;
		my $line_no = 0;
		my $total_lines = @$lines;
		my @source;
		my $comment = 1;
		my $funct = 0;
		SWITCH: for (my $i = 0; $i< ($total_lines); ++$i) {
				$cur_line =  $$lines[$line_no++];
				chomp $cur_line;
				my $type = eval_line($cur_line);
				if ($type == 0) {
						$comment = 1;
						next SWITCH; 
				}
				if ($type == 1) {
						next SWITCH if $comment;
						$funct = 1;
						@source[$#source + 1] = $cur_line; 
						next SWITCH;
				}
				if ($type == 2) {
						next SWITCH if $comment;
						@source[$#source + 1] = $cur_line; 
						$funct = 0;
						next SWITCH;
				}
				if ($type == 3) {
						next SWITCH if $comment;
						@source[$#source + 1] = $cur_line if $funct; 
						next SWITCH;
				}
				if ($type == -1) {
						$comment = 0;
				}
		}
		return @source;
}

sub eval_line {
	my $line = shift;
	if  ($line =~ /^\/\*/) {
			return -1 if ($line =~ /\*\//);
			return 0;
	}
	return -1 if  ($line =~ /\*\//);
	return 1 if  ($line =~ /^[ \t]*([A-Z]+)_DECLARE/);
	return 2 if  ($line =~ /\);/);
	return 3;
}

sub eval_ret {
		my $str = shift;
		my %ret;
#		print $str."\n";
#		([^ \t*&]+)
		if ($str =~ /[ \t]*
				(const)*
						[ \t]*
				([^*&]+)#Type [could be unsigned int or long long so discard the space check]
				([\t *&]*)/x) {
				$ret{"parse"} = 1;
				$ret{"const"} = $1;
				$ret{"type"} = $2;
				$ret{"ptrtype"} = $3;
				$ret{"str"} = $str;
		} else {
				$ret{"parse"} = 0;
				$ret{"str"} = $str;
		}
		return \%ret;
}

sub eval_args {
		my $str = shift;
		my @args = split(/,/,$str);
		my @ret;
		my %struct_args;
		if ($str =~ /[.]+/) {
				#Allow just a void * arg in case of varargs, 
				#dangerous and experimental.
						%struct_args  = ("const" => "", "type" => "-------void-------", "ptrtype" => "*","str" =>$arg, "parse" => 0 );
						$ret[$#ret + 1] = \%struct_args;
						return \@ret;
		}
		foreach $arg (@args) {
				if ($arg =~ /[ \t]*
						(const)*#If it is a const
						[ \t]*
						([^ \t*&]+)#datatype name
						[\t ]*
						([*& \t]*)
						.*/x ) {
						%struct_args  = ("const" => $1, "type" => $2, "ptrtype" => $3,"str" =>$arg, "parse" => 1 );
				}else {
						%struct_args  = ("const" => 0, "type" => 0, "ptrtype" => 0 , "str"=>$arg, "parse" => 0);
				}
				$ret[$#ret + 1 ] = \%struct_args;
		}
		return \@ret;
}

sub eval_functs {
	my $func = shift;
	my %ret;
	if ($func =~ /^[ \t]*
			([A-Z]+_DECLARE[_A-Z]*)#decl
			[ \t]*\(
			([^\),]*)#Return Type
			\)[ \t]*
			([^\(]+)#Function Name
			\([ \t]*
			([^\)]+)#Function Args
			(.*)$/x )  {
			$ret{"parse"} = 1;
			$ret{"decl"} = $1;
			$ret{"ret"} = eval_ret($2);
			$ret{"funct"} = $3;
			$ret{"args"} = eval_args($4);
			$ret{"str"} = $func;
			return \%ret;
	} else {
			$ret{"parse"} = 0;
			$ret{"str"} = $func;
			return \%ret;
	}
}

$apache_inc_dir = "C:/work/servers/Apache/2.0.50/Apache2/include";
foreach $file (<${apache_inc_dir}/*.h>) {
		open INFILE , "<$file" or die "cant open $file";
		my $file_name = $file;
		if ($file =~ /.*\/([^.\/]+)[.]+h$/) {
				$file_name = $1;
		}
		open OUTFILE , ">./scheme_$file_name.tpl" or die "cant open $file_name";
		my $out = OUTFILE;
		my @lines  = <INFILE>;
		my @functs = split(/;/, join ( "" , eval_file( \@lines ) ));
		my @func_struct;
		foreach my $func (@functs) {
				$func_struct[$#func_struct+1] = eval_functs($func);
		}
		foreach my $func (@func_struct) {
				if ($func->{"parse"} == 1) {
#-----------------Macro---------------						
						print $out "0,\t";#Macro
#-----------------DataType---------------						
						my $ptr_prefix = &get_ptr_prefix( $func->{"ret"}->{"ptrtype"} );
						print $out $ptr_prefix.$func->{"ret"}->{"type"}.",\t";#ReturnType
#-----------------PtrType---------------						
						if ($func->{"ret"}->{"ptrtype"} =~ /[ \t]*[*]+[ \t]*/) { 
								print $out "0,\t";
						} elsif ($func->{"ret"}->{"ptrtype"} =~ /[ \t]*[&]+[ \t]*/) { 
								print $out "2,\t" ;
						}else {
								print $out "1,\t";
						}
						if ($func->{"funct"} =~ /[ \t]*([^_ \t]+)_([^ \t]+)[ \t]*/x) {
#-----------------LibName---------------						
								print $out $1.",\t";
								print $out $2."\t";#Remove the commas so that arg type can give their own starting
						} else {
								print $out "\t";
						}
#-----------------ArgProcessing---------------
#						print $func->{"args"}[0]->{"type"};
						my $args = $func->{"args"};
						foreach $arg (@$args) {
								print $out ",";
								print $out $ptr_prefix;
								my $ptr_prefix = &get_ptr_prefix( $$arg{"ptrtype"} );
								print $out $ptr_prefix.$$arg{"type"}.",\t";
								my $ptr_type = get_ptr_type($$arg{"ptrtype"});
								print $out $ptr_type;
						}
						print $out "\n";
				} else {
#						print $func->{"str"}."\n";
				}
		}
		close INFILE;
		close OUTFILE;
}

sub get_ptr_type {
		my $ptr_type = shift;
		if ($ptr_type =~ /[ \t]*[*]+[ \t]*/) { 
				return "0";
		} elsif ($ptrtype =~ /[ \t]*[&]+[ \t]*/) { 
				return "2" ;
		}else {
				return "1";
		}
}

sub get_ptr_prefix {
		my $ptr_prefix = shift;
		if ($ptr_prefix =~ /[^ \t]/) {
				$ptr_prefix =~ s/[*]{1}/^/g;
				$ptr_prefix .="_";
		} else {
				$ptr_prefix = "";
		}
		return $ptr_prefix;
}
