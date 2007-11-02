print "\nEnter data>>";
$data = <STDIN>;
chomp $data;
print "[repl enter regexp] \n";
while (<>) {
		chomp;
		if( $data =~ /$_/ ) {
			print "\nmatch [".$data."]\n";
			print "1=[".$1."] 2= [".$2."] 3=[".$3."] 4=[".$4."] 5=[".$5."]\n";
		}
}
