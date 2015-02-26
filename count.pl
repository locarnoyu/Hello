    use strict;
    use warnings;
     
    my %count;
    my $file = shift or die "Usage: $0 FILE\n";
	
	my $directory = '.';

    opendir (DIR, $directory) or die $!;
	while (my $file = readdir(DIR)) {

        print "$file\n";
		if ($file eq "." or $file eq "..")
		{
		    next;
		}

		open my $fh, '<', $file or die "Could not open '$file' $!";
        while (my $line = <$fh>) {
            chomp $line;
	        $line =~ s/[\|\;\:\}\{\<\>\"\?\(\)\=\/\-\.\&\^\$\#\@\!\~\_\,\.\/\[\]\'\\\%]/ /g;
            foreach my $str (split /\s+/, $line) {
                $count{$str}++;
            }
		}	
    }

    
	#exit 0;
    foreach my $name (sort { $count{$a} <=> $count{$b} } keys %count) {
	  if (length($name) > 2){
         printf "%-8s %s\n", $name, $count{$name};
	  }
    }
	
    #foreach my $str (sort keys %count) {
    #    printf "%-31s %s\n", $str, $count{$str};
    #}