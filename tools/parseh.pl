#   The c-header parser script that will parse header looking for functions.
#   Accepts an argument apache include directory which contains the include 
#   files
#
#   I really did not want to write a c-parser, so I looked for some patterns
#   in the apache header files that would help me by with out investing too
#   much of my time. I found that each of the functions are prefixed by 
#   AP/APR_DECLARE and ends with the close paren');', so I used that rule to
#   create a huge array of functions, and tried to match a regular expression
#   to the function declaration, which will fetch me the function name,
#   arguments, and return value. [eval_functs]. while it works in 90% of the
#   cases [my initial target was 70%] it still cannot understand some of the 
#   declarations, these are excluded in <functs.exclude>, some of the 
#   platform specific functions have also been left out this way.
#   some others include the APIs that take a function or a structure as an 
#   argument. I left these out as it is difficult to represent these in scheme.[TODO:]
#   varargs are also ignored.
#

use lib qw(../tools);
use Utils;
#Globals
@g_exclude_function;

$g_out_dir = "gen";
$g_ext = "tpl";

#   The main parser loop, here we analyze the contents of each lines [passed as
#   line from the main header loop], remove comments from it, and parse the 
#   functions
sub eval_file_functs {
    # $lines is a reference to a array passed in.
    my $lines = shift;

    my $line_no = 0;
    my $total_lines = @$lines;
    my @source;
    my $comment = 1;
    my $funct = 0;

    SWITCH: for (my $i = 0; $i< ($total_lines); ++$i) {

        $cur_line =  $$lines[$line_no++];
        chomp $cur_line;

        #Ignore preprocessor directives
        next SWITCH if $cur_line =~ /^#.*$/;

        CONT: my $type = eval_line_functs($cur_line);

        # comment open && not closed.
        if ($type == 0) {
            $comment = 1;
            $cur_line = eat_comments( $cur_line );
            goto CONT; 
        }

        # comment closed.
        if ($type == -1) {
            $comment = 0;
            $cur_line = eat_comments( $cur_line );
            goto CONT;
        } else {
            next SWITCH if $comment;
        }

        # apache macro for function encountered
        if ($type == 1) {
            $funct = 1;

            #make sure that we are not seeing an AP_DECLARE ending in the same line.
            $funct = 0 if  ($line =~ /\);/);

            @source[$#source + 1] = $cur_line; 
            next SWITCH;
        }

        # contains a close paren ');' so we can assume the function closed
        if ($type == 2) {
            @source[$#source + 1] = $cur_line; 
            $funct = 0;
            next SWITCH;
        }

        # ambiguous line, pending further investigation.
        if ($type == 3) {
            @source[$#source + 1] = $cur_line if $funct; 
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

sub eval_line_functs {
    my $line = shift;
    if  ($line =~ /^\/\*/) {
        return -1 if ($line =~ /\*\//);#Closed comment
        return 0;#Open comment
    }
    return -1 if  ($line =~ /\*\//);
    return 1 if  ($line =~ /^[ \t]*([A-Z]+)_DECLARE/);
    return 2 if  ($line =~ /\);/);
    return 3;
}

# Try and parse the return type of the function. eg:
#APU_DECLARE(apr_bucket_brigade *) apr_brigade_create(apr_pool_t *p,
#                                                     apr_bucket_alloc_t *list);
#
sub eval_ret_functs {
    my $str = shift;
    my %ret;
#        print $str."\n";
#        ([^ \t*&]+)
    if ($str =~ /[ \t]*
        (const)*#if it is a constant or not                                             =>$1
        [ \t]*
        ([^*&]+)#Type [could be unsigned int or long long so discard the space check]   =>$2
        ([\t *&]*)/x) {# checking if it contains any references or pointers (* , & etc) =>$3
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

# Try to assimilate the arguments to the function. We do not handle varargs since 
# it is difficult to use it with scheme.
#APR_DECLARE(apr_status_t) apr_getopt_long(apr_getopt_t *os,
#                      const apr_getopt_option_t *opts,
#                      int *option_ch,
#                                          const char **option_arg);
#
sub eval_args_functs {
    my $str = shift;
    my @args = split(/,/,$str);
    my @ret;
    my $struct_args;

    # varargs not handled so ignore them
    if ($str =~ /[.]+/) {
        #$struct_args  = ("const" => "", "type" => "-------void-------", "ptrtype" => "*","str" =>$arg, "parse" => 0 ,"vargs"=>1);
        #$ret[$#ret + 1] = \%struct_args;
        #return \@ret;
        return -1;
    }


    #arg specimens
    #funct(void)
    #const char * const *args, 
    #char const * const * *argv
    #const unsigned char *
    #struct iovec *vec
    #void (*free_func)(void *data)
    #unsigned flag


    foreach $arg (@args) {
        # We try to handle all special cases first. 

        # We dont really care about constant arguments, so remove them.
        $arg =~ s/\bconst\b/ /g;

        # if it is a species that needs no input, return immediatly.
        if ($arg =~ /^[ \t]*void[ \t]*$/ ) { 
            #$struct_args  = {"const" => "", "type" => "", "ptrtype" => "","str" =>$arg, "parse" => 1 };
            return 0;

        }elsif ($arg =~ /[ \t]*\(.*\)[ \t]*\(.*\)[ \t]*$/) {#function pointer
            # if it is a function pointer, we cheat by saying it takes an int instead and passes it 0 so
            # it will never see the function pointer as a real function
            $struct_args  = {"type" => "int", "ptrtype" => "","str" =>$arg, "parse" => 1 };

        }elsif ($arg =~ /^[ \t]*([a-zA-Z_]+)[ \t]+([a-zA-Z_]+)[ \t]*$/) {
            # it is a normal honest to god argument with out pointers and stuff [like "int mexico"]
            # we remove the name of argument since it is not needed by us.(we need only signature for the function)
            $struct_args  = {"type" => $1, "ptrtype" => "","str" =>$arg, "parse" => 1 };

        }elsif ($arg =~ /[ \t]*
            (unsigned|struct)*#If it is an unsigned or a struct         =>$1
            [ \t]*
            ([^ \t*&]+)#datatype name                                   =>$2
            ([*& \t]*)#pointers or references                           =>$3
            [\t ]*
            .*/x ) {
            $struct_args  = {"type" => $1." ".$2, "ptrtype" => $3,"str" =>$arg, "parse" => 1 };
        }else {
            $struct_args  = {"type" => 0, "ptrtype" => 0 , "str"=>$arg, "parse" => 0};
        }
        $ret[$#ret + 1 ] = $struct_args;
    }
    return \@ret;
}

# The little big guy.
# We try to fit a hefty regular expression to the function string given to us, If we succeed
# we populate the return structure with the gems, else we simply say unparsed and leave it to its fate.

# APR_DECLARE(apr_status_t) apr_getopt_init(apr_getopt_t **os, apr_pool_t *cont,
#                                      int argc, const char * const *argv);

sub eval_functs {
    my $func = shift;
    my %ret;
    if ($func =~ /^[ \t]*
        ([A-Z]+_DECLARE[_A-Z]*)#decl =>$1
        [ \t]*\(
        ([^\),]*)#Return Type        =>$2
        \)[ \t]*
        ([^\(]+)#Function Name       =>$3
        \([ \t]* #first bracket
        (.+)#Function Args           =>$4
        \)[ \t]*$/x )  {
        $ret{"parse"} = 1;
        $ret{"decl"} = $1;
        $ret{"ret"} = eval_ret_functs($2);
        $ret{"funct"} = $3;
        $ret{"args"} = eval_args_functs($4);
        $ret{"str"} = $func;
        return \%ret;
    } else {
        $ret{"parse"} = 0;
        $ret{"str"} = $func;
        return \%ret;
    }
}

#   The main header loop, we iterate through each file in the includes directory,
#   and pass it to the capable functions to parse and construct a symbol table 
#   out of it

sub header_loop {
    my $apache_inc_dir = shift;
    foreach $file (<${apache_inc_dir}/*.h>) {

        # exclude_header checks if we have been explicitly asked to ignore this 
        # header file, [which may happen if it is platform specific or np]
        next if exclude_header($file);

        my $file_name = &get_base_name( $file );

        open INFILE , "<$file" or die "cant open $file";
        open OUTFILE , ">./${g_out_dir}/scheme_$file_name.${g_ext}" or die "cant open $file_name";

        my $out = OUTFILE;
        my @lines  = <INFILE>;


        # Move on to the main parser loop. eval_file_functs clears the file of comments
        # and captures all the function declarations [AP/APR_DECLARE] into one big array.
        my @functs = split(/;/, join ( "" , eval_file_functs( \@lines ) ));


        # Take the String array of functions and transform them into a parsed datastructure.
        my @func_struct;
        foreach my $func (@functs) {
            $func_struct[$#func_struct+1] = eval_functs($func);
        }


        foreach my $func (@func_struct) {

            #ignore all the excluded functions
            next if exclude_function($func->{"funct"});

            #print the table only if we were able to parse
            if ($func->{"parse"} == 1) {

                # If we had a varargs function [eval_args_functs returned -1] write it out as comment
#-----------------Varargs---------------                        
                if ($func->{"args"} == -1 ) {
                    print $out "#";#comment
                }

                # We denote the difference between a macro and a function by 0=>function 1=>macro in 
                # the table
#-----------------Macro---------------                        
                print $out "0,\t";#Macro

                # get_ptr_prefix generates a string from the pointer type ie. * x == ^_x and **x => ^^_x
#-----------------Return DataType---------------
                my $ptr_prefix = &get_ptr_prefix( $func->{"ret"}->{"ptrtype"} );
                print $out $ptr_prefix.$func->{"ret"}->{"type"}.",\t";#ReturnType

                # We use 0 to denote generic pointers and 2 to denote references 1 for things which are not ptrs
#-----------------PtrType---------------
                print $out get_ptr_type( $func->{"ret"}->{"ptrtype"} ).",\t";

                # Check its library namespace. Since all apache exports starts with AP or APR
                # we assume AP_XXX is of library AP and APR_XXX is of library APR
#-----------------LibName---------------                        
                if ($func->{"funct"} =~ /[ \t]*([^_ \t]+)_([^ \t]+)[ \t]*/x) {
                    print $out $1.",\t";
                    print $out $2."\t";#Remove the commas so that arg type can give their own starting
                } else {
                    print $out "\t";
                }


#-----------------ArgProcessing---------------
                #print $func->{"args"}[0]->{"type"};
                my $args = $func->{"args"};
                if ($args != 0 ) {
                    foreach $arg (@$args) {
                        print $out ",";
                        my $ptr_prefix = &get_ptr_prefix( $$arg{"ptrtype"} );
                        print $out $ptr_prefix.$$arg{"type"}.",\t";
                        my $ptr_type = get_ptr_type($$arg{"ptrtype"});
                        print $out $ptr_type;
                    }
                }
                print $out "\n";
            } else {
                print $out "#".$func->{"str"}."\n";
            }
        }
        close INFILE;
        close OUTFILE;
    }
}

sub init_excludes {
    open EXCLUDE_FUNCT , "<functs.exclude" or die "cant open functs.exclude";
    @g_exclude_function = <EXCLUDE_FUNCT>;
    close EXCLUDE_FUNCT;

    &init_exclude_header("headers.exclude");
}

sub exclude_function {
    my $arg = shift;
    foreach my $line (@g_exclude_function) {
        chomp $line;
        next if $line =~ /^[ \t]*$/;
        next if $line =~ /^[ \t]*#/;
        return 1 if $arg =~ $line;
    }
    return 0;
}

#   Start the whole thing and cross your fingers.
&init_excludes;
foreach my $inc (@ARGV) {
    &header_loop($inc);
}
