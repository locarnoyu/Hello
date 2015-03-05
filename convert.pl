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
	    print "$cwd \n";
		opendir (DIR, ".") or die $!;
		while (my $file = readdir(DIR)) {
			if ($file eq "." or $file eq "..")
			{
				next;
			}
            if (index($file, "html") != -1) {
			    unless (-e $file)
				{
					print "$file to convert \n";
					my $orginal_file = $file;
					$file =~ s/html/txt/g;
					system ( "perl ..\/html2text.pl $orginal_file > $file ");  
				}
			}
			if (index($file, "html") == -1 && index($file, "txt") == -1) {
					print "$file to convert \n";
					my $new_file = $file.".txt";
					system ( "perl ..\/html2text.pl $file > $new_file ");  

		    }
		}
		chdir $root;
	}
