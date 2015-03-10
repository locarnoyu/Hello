    use strict;
    use warnings;
	use Cwd;
	use List::MoreUtils 'any';

	
    my %count;
	my $directory;

	
sub filter ($)
{
    my ($word, $match_found) = @_;
	my @filter1 = ("the","and","false","com","var","function","for","true","this","http","with","data","you","that","class","https","document","url","text");
	my @filter2 = ("your","div","new","jpg","2015","type","name","window","more","time","null","all","image","from","images","title","jquery","width","src","www");
	my @filter3 = ("2014","return","are","not","will","top","href","u003c","net","but","can","product","value","has","have","its","see","page","span","else","post");

#	$match_found = any { /$word/ } @filter1;
#	if (!defined $match_found)
#	{
#		$match_found = any { /$word/ } @filter2;
#	}
#	if (!defined $match_found)
#	{
#		$match_found = any { /$word/ } @filter3;
#	}
	$match_found = grep(/^$word/i, @filter1);
	if ( $match_found == 0 )
	{
	$match_found = grep(/^$word/i, @filter2)
	}
	if ( $match_found == 0)
	{
	$match_found = grep(/^$word/i, @filter3)
	}
	return $match_found ;
}

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
			if ($file eq "." or $file eq ".." or index($file, "txt") == -1)
			{
				next;
			}

			open my $fh, '<', $file or die "Could not open '$file' $!";
			while (my $line = <$fh>) {
				chomp $line;
				$line =~ s/[\|\;\:\}\{\<\>\"\?\(\)\=\/\-\.\&\^\$\#\@\!\~\_\,\.\/\[\]\'\\\%\*\+]/ /g;
				foreach my $str (split /\s+/, $line) {
                    $str = lc $str;				
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
		 my $return = filter ($name);
		 if ( $return != 1)
		 {
			printf "\"%-8s\" %s\n", $name, $total if ($total > 50);
		 }
	  }
    }
	
    #foreach my $str (sort keys %count) {
    #    printf "%-31s %s\n", $str, $count{$str};
    #}