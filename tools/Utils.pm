package Utils;

BEGIN {
    use Exporter ();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

    $VERSION = 1.00;
    @ISA = qw(Exporter);

    @EXPORT=qw(init_exclude_header exclude_header get_base_name eat_comments get_ptr_prefix get_ptr_type );
    %EXPORT_TAGS = ( );
    @EXPORT_OK = ();
}
our @EXPORT_OK;

sub get_base_name {
    my $file = shift;
    if ($file =~ /.*\/([^.\/]+)[.]+h$/) {
        return $1;
    }
    return $file;
}

# exclude_header checks if we have been explicitly asked to ignore this 
# header file, [which may happen if it is platform specific or np]
@g_exclude_header;

sub init_exclude_header {
    my $file = shift;
    open EXCLUDE , "<${file}" or die "cant open ${file}";
    @g_exclude_header = <EXCLUDE>;
    close EXCLUDE;
}

sub exclude_header {
    my $file = shift;
    foreach my $line (@g_exclude_header) {
        chomp $line;
        next if $line =~ /^[ \t]*$/;
        next if $line =~ /^[ \t]*#/;
        return 1 if $file =~ $line;
    }
    return 0;
}

sub eat_comments {
    $text_line = shift;
    $text_line =~ s{/\*.*?\*/} []gsx;
    $text_line =~ s/\/\*.*?$//g;
    $text_line =~ s/^.*?\*\///g;
    return $text_line;
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

1;
