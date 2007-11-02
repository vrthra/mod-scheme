#   The c-header parser script that will parse header looking for Structures.
#   Accepts an argument apache include directory which contains the include 
#   files
#
#   This parser just looks for things that start with struct and ends with
#   a '};' [like the parseh.pl that looks for functions]
#
use lib qw(../tools);
use Utils;
#Globals

$g_out_dir = "gen";
$g_ext = "stpl";
$apache_inc_dir = shift @ARGV;
@g_exclude_struct;


#   The main parser loop, here we analyze the contents of each lines [passed as
#   line from the main header loop], remove comments from it, and parse the structs

sub eval_file_structs {
    #lines is a reference to the array passed in.
    my $lines = shift;

    my $line_no = 0;
    my $total_lines = @$lines;
    my @source;
    my $comment = 1;
    my $struct = 0;

    SWITCH: for (my $i = 0; $i< ($total_lines); ++$i) {

        $cur_line =  $$lines[$line_no++];
        chomp $cur_line;

        #Ignore preprocessor directives
        next SWITCH if $cur_line =~ /^#.*$/;

        CONT: my $type = eval_line_structs($cur_line);

        #comment open && not closed
        if ($type == 0) {
            $comment = 1;
            $cur_line = eat_comments( $cur_line );
            goto CONT;
        }

        #comment closed
        if ($type == -1) {
            $comment = 0;
            $cur_line = eat_comments( $cur_line );
            goto CONT;
        } else {
            next SWITCH if $comment;
        }

        #struct declaration encountered
        if ($type == 1) {
            $struct = 1;
            @source[$#source + 1] = $cur_line;
            next SWITCH;
        }
        #contains a '};' so assume the struct declaration ended.
        #will fail for internal structs and unions. TODO:
        if ($type == 2) {
            @source[$#source + 1] = $cur_line if ($struct == 1);
            $struct = 0;
            next SWITCH;
        }
        # ambiguous line, pending further investigation.
        if ($type == 3) {
            @source[$#source + 1] = $cur_line if $struct; 
            next SWITCH;
        }
    }
    return @source;
}


# We evaluate the line that we are given and determine if it
#       has a comment starting,
#           return -1 if the comment ends in the same line, pending further parsing
#           return 0 indicating that the comment continues
#       return -1 if it is a line in which the comment ends.
#       return 1 if it is the function declaration macro.
#       return 2 if it contains a close paran ');' signifying a funciton end
#       return 3 if other wise.

# We assume here that only one comment is there in a single line => only
# one /* and or */ in a single line.
#
sub eval_line_structs {
    my $line = shift;
    if  ($line =~ /^.*\/\*/) {
        return -1 if ($line =~ /\*\//);#Closed comment
        return 0;#Open comment
    }
    return -1 if  ($line =~ /.*\*\/.*/);#comment end;...........*/.........
    return 1 if  ( $line =~ /^[ \t]*struct[ \t]+[a-zA-Z_]+[ \t]+[{]+/ );
    return 1 if  ( $line =~ /^[ \t]*typedef[ \t]+struct[ \t]+[a-zA-Z_]+[ \t]+[{]+/ );                   #fmt--}}
    return 2 if  ($line =~ /\}[ \t]*;/);
    return 2 if  ($line =~ /\}[ \t]*[^ \t;]+[ \t]*;/);
    return 3;
}

# The converters, We convert the data type name [get_def] and the structure name [get_def_st]
# to what is defined in type.define and struct.define so that they are easier to use.
my %g_type_defs;
sub init_def {
    open DEF, "< type.define" or die "cant open type.define";
    my @definitions = <DEF>;
    close DEF;
    @definitions = map {chomp;$_} @definitions;
    %g_type_defs = map { ($key,$val) = split /=/ ; $key => $val } @definitions;
}
sub get_def {
    my $arg = shift;
    $arg =~ s/[ \t\n]+//g;
    return $g_type_defs{$arg} if exists $g_type_defs{$arg};
    return $arg;
}

my %g_structure_defs;
sub init_def_st {
    open DEF_ST, "< struct.define" or die "cant open struct.define";
    my @definitions_st = <DEF_ST>;
    close DEF_ST;
    @definitions_st = map {chomp;$_} @definitions_st;
    %g_structure_defs = map { ($key,$val) = split /=/ ; $key => $val } @definitions_st;
}
sub get_def_st {
    my $arg = shift;
    $arg =~ s/[ \t\n]+//g;
    return $g_structure_defs{$arg} if exists $g_structure_defs{$arg};
    return $arg;
}


# Try to assimilate the members of the structure we do not deal with internal definitions for now,
# that includes unions, internal structs or any other construct we cant parse.
#
sub eval_args_structs {
    my $args = shift;
    my $struct_name = shift;
    my @args = split(/;/,$args);
    my @arg_array;
    foreach $arg (@args) {
        my %struct_args;
        $arg =~ s/\bconst\b/ /g;
        if ($arg =~ /^(.*[ \t]+[*]*)([^() \t*]+)$/) {
            my $member_name = $2;
            my $return_type = $1;
            #specimens
            #APR_RING_HEAD(apr_bucket_list, apr_bucket) list
            $return_type =~ s/\wconst\w//g; #we cant deal with constants
            $return_type = get_def($return_type);
            next if $return_type =~ /&/; #we cant deal with addresses now.
            if ($return_type =~ /[ \t]*
                ([^ \t*&]+)#datatype name
                [\t ]*
                ([*& \t]*)
                .*/x ) {
                %struct_args  = ("struct" => get_def_st($struct_name), "type" => $1, "ptrtype" => $2,"member" => $member_name,"str" =>$arg, "parse" => 1 );
            }else {
                %struct_args  = ("struct" => get_def_st($struct_name), "type" => 0, "ptrtype" => 0 ,"member"=>$member_name, "str"=>$arg, "parse" => 0);
            }
        } else {next;}
        $arg_array[$#arg_array + 1] = \%struct_args;
    }
    return \@arg_array;
}

# The structure definitions can come in two forms, simple 
# struct my_name {
# };
# and 
# typedef struct my_name {
# } real_name;
sub eval_struct {
    my $struct = shift;
    if ($struct =~ /^[ \t]*struct[ \t]+([^{ \t]+)[ \t]*[{]+(.*)[}]+[ \t]*;[ \t]*$/) { #--fmt }
        my $struct_name = $1;
        return eval_args_structs($2,$struct_name);
    }
}

sub eval_typedef {
	my $struct = shift;
	if ($struct =~ /^[ \t]*typedef[ \t]*struct[ \t]+([^{ \t]+)[ \t]*[{]+(.*)[}]+[ \t]*([^ \t;]+)[ \t]*;[ \t]*$/) {
			my $struct_name = $3;
			return eval_args_structs($2,$struct_name);
	}
}
sub eval_structs {
    my $struct = shift;
    return eval_typedef($struct) if ($struct =~ /^[ \t]*typedef/);
    return eval_struct($struct) if ($struct =~ /^[ \t]*struct/);
    return "cant eval. not good";
}

sub init_excludes {
    open EXC, "< struct.exclude" or die "cant open struct.exclude";
    @g_exclude_struct = <EXC>;
    close EXC;
}

sub exclude_struct {
    my $arg = shift;
    foreach (@g_exclude_struct) {
        chomp ;
        return 1 if ($arg =~ /$_/);
    }
    return 0;
}

sub exclude_struct_member {
    my $arg = shift;
    return exclude_struct $arg;
}

sub eat_tabs{
		my $var = shift;
		$var =~ s/[ \t]*//g;
		return $var;
}

sub header_loop {
    foreach $file (<${apache_inc_dir}/*.h>) {

        # exclude_header checks if we have been explicitly asked to ignore this 
        # header file, [which may happen if it is platform specific or np]
        next if exclude_header( $file );

        my $file_name = get_base_name( $file );

        open INFILE , "<$file" or die "cant open $file";
        open OUTFILE , ">./${g_out_dir}/scheme_$file_name.${g_ext}" or die "cant open $file_name";

        my $out = OUTFILE;
        my @lines  = <INFILE>;

        # Move on to the main parser loop. eval_file_structs clears the file of comments
        # and captures all the structure declarations into one big array.
        # the cute regular expression says this. => any thing that is of the form xxx}yyy;
        # We need this because of the two forms of structure declaration:
        #   struct aaa {
        #       bb;
        #       cc;
        #   }; and
        #   typedef struct aaa {
        #       bb;
        #       cc;
        #   } xxx;
        #   so we take the easy way out, and split it with the below regex, but since we do not want
        #   to loose the separation string [type name eg: xxx] from a typedef, we split it with parens
        #   which saves the separation string as an item in the list, and loops thru, two items at a time,
        #   joining them consecutive terms to get a full struct declaration.
        #
        #   We have two checks for exclusion, one the exclusion struct which excludes the whole struct and
        #   exclude member which excludes individual memebers from going into the template files.
        #--fmt {{
        my @structs = split(/([}]+[^}{;]*;)/, join ( "" , eval_file_structs( \@lines ) ));

        for (my $i = 0; $i < $#structs; $i += 2) {
            my $arg_array = eval_structs($structs[$i].$structs[$i+1]);
            foreach my $arg (@$arg_array) {
                if ((length($arg->{"str"}) > 0) && 
                    (!exclude_struct($arg->{"struct"})) && 
                    (!exclude_struct_member($arg->{"struct"}."->".$arg->{"member"}))) {

                    #----------Print the pointer prefix and create a variable type ie ^^_char for **char
                    print $out &get_ptr_prefix($arg->{"ptrtype"});
                    print $out &eat_tabs($arg->{"type"}).",\t\t";

                    #----------The type of pointer -- reference -- ptr -- or normal
                    print $out &get_ptr_type($arg->{"ptrtype"});

                    #----------Library name [all structures are in the lib apache]
                    print $out ",\tapache\t,";

                    #----------the structure and member names
                    print $out $arg->{"struct"}.",\t";
                    print $out $arg->{"member"}."\n" 
                }
            }
        }
        close INFILE;
        close OUTFILE;
    }
}

&init_excludes;
&init_def;
&header_loop;
