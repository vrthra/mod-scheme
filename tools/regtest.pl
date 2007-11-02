print "\nEnter Regexp>>";
$regexp = <STDIN>;
chomp $regexp;
print "[repl enter data] \n";
while (<>) {
		print "\nmatch [".$regexp."]" if /$regexp/;
}
