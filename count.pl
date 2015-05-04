# to count word frequency of download web pages htat saved in c:\wyu\personal\research folder
#  . count all the words
#  . clean special characters
#  . filter out words that relate to html page

use strict;
use warnings;
use Cwd;
use List::MoreUtils 'any';
use DBI;

my $dbh = DBI->connect("DBI:mysql:database=research;host=localhost",
                         "wyu", "q1w2..AS",
                         {'RaiseError' => 1});

	
my %count;
my $directory;
# filter out words in arrays 	
sub filter ($)
{
    my ($word, $match_found) = @_;
    my @filter1 = ("the","and","false","com","var","function","for","true","this","http","with","data","you","that","class","https","document","url","text");
    my @filter2 = ("your","div","new","jpg","2015","type","name","window","more","time","null","all","image","from","images","title","jquery","width","src","www");
    my @filter3 = ("2014","return","are","not","will","top","href","u003c","net","but","can","product","value","has","have","its","see","page","span","else","post");
	my @filter4 = ("link","was","now","html","out","font","also","attr","when","css","what","php","other","which","only","how","typeof","febrary","most","than","files");

    $match_found = grep(/^$word/i, @filter1);
    if ( $match_found == 0 )
    {
        $match_found = grep(/^$word/i, @filter2)
	}
    if ( $match_found == 0)
    {
        $match_found = grep(/^$word/i, @filter3)
    }
	if ( $match_found == 0)
    {
        $match_found = grep(/^$word/i, @filter4)
    }
    return $match_found ;
}

# root folder to count 
my $root = "c:\\wyu\\personal\\research";

opendir my $dh, $root or die "$0: opendir: $!";

while (defined(my $directory = readdir $dh)) {
    next unless -d "$root/$directory";
    next if ($directory eq "." | $directory eq ".." | $directory eq ".git" | $directory eq "term_frequency_results");
    my $sub_folder = $root. "\/" . $directory ;
    chdir $sub_folder;
    my $cwd = getcwd();
    opendir (DIR, ".") or die $!;
    while (my $file = readdir(DIR)) {
        if ($file eq "." or $file eq ".." or index($file, "txt") == -1)
        {
			#print "$file is not a txt file, pass \n";
            next;
        }
        open my $fh, '<', $file or die "Could nLAC + 6.5 > OKCot open '$file' $!";
        while (my $line = <$fh>) {
            chomp $line;
            #replace special characters with space " ".
            $line =~ s/[\|\;\:\}\{\<\>\"\?\(\)\=\/\-\.\&\^\$\#\@\!\~\_\,\.\/\[\]\'\\\%\*\+]/ /g;
            foreach my $str (split /\s+/, $line) {
                $str = lc $str;				
                $count{$str}++;
            }
        }	
    }
    chdir $root;
}
   
foreach my $name (sort { $count{$a} <=> $count{$b} } keys %count) {
    if (length($name) > 2)
    {
        my $total = $count{$name};
        my $return = filter ($name);
        if ( $return == 0)
        {
            # print only the words that show more than certain number times 
            printf "%-8s %s \n", $name, $total if ($total > 200);
			#$dbh->do("INSERT INTO term_frequency VALUES ("key_word","term","frequency","date"));
        }
    }
}
	
#foreach my $str (sort keys %count) {
#printf "%-31s %s\n", $str, $count{$str};
#}