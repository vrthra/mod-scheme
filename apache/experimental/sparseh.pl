sub eval_file {
		my $lines = shift;
		my $line_no = 0;
		my $total_lines = @$lines;
		my @source;
		my $comment = 1;
		my $struct = 0;
		SWITCH: for (my $i = 0; $i< ($total_lines); ++$i) {
				$cur_line =  $$lines[$line_no++];
				chomp $cur_line;
				my $type = eval_line($cur_line);
				if ($type == 0) { #We have a comment start; ......../*......... with out comment end
						$comment = 1;
						if ($cur_line =~ /^([^*]*)\/\*[ \t]*$/) {
								my $type_1 = eval_line($1);
								if ($type_1 == 1) {
										@source[$#source +1 ] = $1 ; #add it to the source if the type of rest of line is struct
										$struct = 1;
								}
						}
						next SWITCH; 
				}
				if ($type == 1) { #we have a struct declaration starting here.
						next SWITCH if $comment;
						$struct = 1;
						@source[$#source + 1] = $cur_line;
						next SWITCH;
				}
				if ($type == 2) {
						next SWITCH if $comment;
						@source[$#source + 1] = $cur_line if ($struct == 1);
						$struct = 0;
						next SWITCH;
				}
				if ($type == 3) {
						next SWITCH if $comment;
						@source[$#source + 1] = $cur_line if $struct; 
						next SWITCH;
				}
				if ($type == -1) {
						$comment = 0;
						if ($cur_line =~ /^(.*)\/\*.*\*\/(.*)$/) {
								my $type_1 = eval_line($1." ".$2);
								$source[$#source + 1] = $1." ".$2 if (($type_1 == 1 ) || ($struct == 1) ); #add it to the source if and only if it starts a struct decl or it is in the middle of a struct
								$struct = 1 if ($type_1 == 1);
								next SWITCH;
						}
						if ($cur_line =~ /^.*\*\/(.*)$/) {
								my $type_1 = eval_line($1);
								$source[$#source + 1] = $1 if (($type_1 == 1 ) || ($struct == 1) ); #add it to the source if and only if it starts a struct decl or it is in the middle of a struct
								$struct = 1 if ($type_1 == 1);
						}
				}
		}
		return @source;
}

sub eval_line {
	my $line = shift;
	if  ($line =~ /^.*\/\*/) { #we have comment starting. .............../*.............?*/?...
			return -1 if ($line =~ /\*\//);#the comment is of the form ......../*......*/.........
			return 0;
	}
	return -1 if  ($line =~ /.*\*\/.*/);#comment end;...........*/.........
	return 1 if  ( $line =~ /^[ \t]*struct[ \t]+[a-zA-Z_]+[ \t]+[{]+/ );
	return 1 if  ( $line =~ /^[ \t]*typedef[ \t]+struct[ \t]+[a-zA-Z_]+[ \t]+[{]+/ );
	return 2 if  ($line =~ /\}[ \t]*;/);
	return 2 if  ($line =~ /\}[ \t]*[^ \t;]+[ \t]*;/);
	return 3;
}

sub eval_args {
		my $args = shift;
		my $struct_name = shift;
		my @args = split(/;/,$args);
		my @arg_array;
		foreach $arg (@args) {
				my %struct_args;
				if ($arg =~ /^(.*[ \t]+[*]*)([^ \t*]+)$/) {
						my $member_name = $2;
						my $return_type = $1;
						if ($return_type =~ /[ \t]*
								(const)*#If it is a const
								[ \t]*
								([^ \t*&]+)#datatype name
								[\t ]*
								([*& \t]*)
								.*/x ) {
								%struct_args  = ("struct" => $struct_name, "const" => $1, "type" => $2, "ptrtype" => $3,"member" => $member_name,"str" =>$arg, "parse" => 1 );
						}else {
								%struct_args  = ("struct" => $struct_name, "const" => 0, "type" => 0, "ptrtype" => 0 ,"member"=>$member_name, "str"=>$arg, "parse" => 0);
						}
				}
				$arg_array[$#arg_array + 1] = \%struct_args;
		}
		return \@arg_array;
}

sub eval_struct {
	my $struct = shift;
	if ($struct =~ /^[ \t]*struct[ \t]+([^{ \t]+)[ \t]*[{]+(.*)[}]+[ \t]*;[ \t]*$/) {
			my $struct_name = $1;
			return eval_args($2,$struct_name);
	}
}
sub eval_typedef {
	my $struct = shift;
	if ($struct =~ /^[ \t]*typedef[ \t]*struct[ \t]+([^{ \t]+)[ \t]*[{]+(.*)[}]+[ \t]*([^ \t;]+)[ \t]*;[ \t]*$/) {
			my $struct_name = $3;
			return eval_args($2,$struct_name);
	}
}
sub eval_structs {
		my $struct = shift;
		return eval_typedef($struct) if ($struct =~ /^[ \t]*typedef/);
		return eval_struct($struct) if ($struct =~ /^[ \t]*struct/);
		return "cant eval. not good";
}


$apache_inc_dir = ".";
foreach $file (<${apache_inc_dir}/*.h>) {
		open INFILE , "<$file" or die "cant open $file";
		my $file_name = $file;
		if ($file =~ /.*\/([^.\/]+)[.]+h$/) {
				$file_name = $1;
		}
		open OUTFILE , ">./scheme_$file_name.stpl" or die "cant open $file_name";
		my $out = OUTFILE;
		my @lines  = <INFILE>;
		my @structs = split(/([}]+[^}{;]*;)/, join ( "" , eval_file( \@lines ) ));
		for (my $i = 0; $i < $#structs; $i += 2) {
				my $arg_array = eval_structs($structs[$i].$structs[$i+1]);
				foreach my $arg (@$arg_array) {
						print $out &get_ptr_prefix($arg->{"ptrtype"}).&trim($arg->{"type"}).",\t\t".&get_ptr_type($arg->{"ptrtype"}).",\tapache\t,".$arg->{"struct"}.",\t".$arg->{"member"}."\n";
				}
		}
		close INFILE;
		close OUTFILE;
}

sub trim {
		my $var = shift;
		$var =~ s/[ \t]*//g;
		return $var;
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
		$ptr_prefix =~ s/[ \t]+//g;
		if ($ptr_prefix =~ /[^ \t]/) {
				$ptr_prefix =~ s/[*]{1}/^/g;
				$ptr_prefix .="_";
		} else {
				$ptr_prefix = "";
		}
		return $ptr_prefix;
}
