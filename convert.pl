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
			if ($file eq "." or $file eq ".." or index($file, "txt") != -1 or index($file, "pl") != -1 or index($file, "log") != -1)
			{
				# converted file because file name include "txt"
				next;
			}
			# check html file
            if (index($file, "html") != -1) {
			    #print "html file $file \n";
			    if (-e $file)
				{
					my $orginal_file = $file;
					$file =~ s/html/txt/g;
					if (-e $file)
					{
						#print "file $orginal_file already converted! 1 \n";
						next;
					}
					else
					{
						print "$file to convert 1\n";
						system ( "perl ..\/html2text.pl $orginal_file > $file ");  
					}
				}
			}
			else
			{
			   # old files that dont have .html extention
				my $new_file = $file.".txt";
				if (-e $new_file)
				{
					#print "file $file already converted! 2 \n";
					next;
				}
                print "old $file to convert 2\n";					
				system ( "perl ..\/html2text.pl $file > $new_file ");  
		    }
		}
		chdir $root;
	}
