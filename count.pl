    use strict;
    use warnings;
	use Cwd;
	
	
    my %count;
	my $directory;

	my $root = "c:\\wyu\\personal\\research";

    opendir my $dh, $root or die "$0: opendir: $!";

    while (defined(my $directory = readdir $dh)) {
        next unless -d "$root/$directory";
		#print "path = $root/$directory \n";
		next if ($directory eq "." | $directory eq ".." | $directory eq ".git" | $directory eq "term_frequency_results");
		my $sub_folder = $root. "\/" . $directory ;
		chdir $sub_folder;
		#system ("cd $sub_folder");
		my $cwd = getcwd();
	    #print "$cwd \n";
		opendir (DIR, ".") or die $!;
		while (my $file = readdir(DIR)) {
			if ($file eq "." or $file eq ".." or index($file, "txt") == -1))
			{
				next;
			}

			open my $fh, '<', $file or die "Could not open '$file' $!";
			while (my $line = <$fh>) {
				chomp $line;
				$line =~ s/[\|\;\:\}\{\<\>\"\?\(\)\=\/\-\.\&\^\$\#\@\!\~\_\,\.\/\[\]\'\\\%\*\+]/ /g;
				foreach my $str (split /\s+/, $line) {
					$count{$str}++;
				}
			}	
		}
		chdir $root;
		#system ("cd ..");
	}

   
	#exit 0;
    foreach my $name (sort { $count{$a} <=> $count{$b} } keys %count) {
	  if (length($name) > 2){
	     my $total = $count{$name} ;
		 printf "%-8s %s\n", $name, $total if ($total > 50);
	  }
    }
	
    #foreach my $str (sort keys %count) {
    #    printf "%-31s %s\n", $str, $count{$str};
    #}