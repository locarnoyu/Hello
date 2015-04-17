# to count word frequency of download web pages htat saved in c:\wyu\personal\research folder
#  . count all the words
#  . clean special characters
#  . filter out words that relate to html page

use strict;
use warnings;
use Cwd;
use List::MoreUtils 'any';
use DBI;
use File::Stat;

my $dbh = DBI->connect("DBI:mysql:database=research;host=localhost",
                         "wyu", "q1w2..AS",
                         {'RaiseError' => 1});

my $num_args = $#ARGV + 1;
if ($num_args != 3) {
    print "\nUsage: file_size.pl folder key date\n";
    exit;
}
 
# (2) we got two command line args, so assume they are the
# first name and last name
my $folder_name=$ARGV[0];
my $key_word=$ARGV[1];
my $search_date = $ARGV[2];

my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
my @days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
print "$mday $months[$mon] $days[$wday]\n";
 	
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
my $root = "C:\\wyu\\personal\\research\\". $folder_name . "\\version.txt";

print "root = $root \n";
open(DATA, "<$root") or die "Couldn't open file file.txt, $!";

while(<DATA>){
   #print "$_";
   if( $_ =~ /^(\d+)\t(\S+)/ )
    {
        my $file_name = $1;
		$file_name = "C:\\wyu\\personal\\research\\". $folder_name ."\\".$file_name . ".html";
        my $link = $2;
		print "file name = $file_name and link = $link \n";
		my $filesize = -s "$file_name";
        print "Size: $filesize\n";
		$dbh->do("INSERT INTO link_size  VALUES ( '$key_word', '$search_date', '$link', '$filesize')");
    }
}

exit 0;
#opendir my $dh, $root or die "$0: opendir: $!";

    chdir $root;
    my $cwd = getcwd();
    opendir (DIR, ".") or die $!;
    while (my $file = readdir(DIR)) {
        if ($file eq "." or $file eq ".." or index($file, "txt") == -1)
        {
			#print "$file is not a txt file, pass \n";
            next;
        }
        open my $fh, '<', $file or die "Could not open '$file' $!";
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
   
foreach my $name (sort { $count{$a} <=> $count{$b} } keys %count) {
    if (length($name) > 2)
    {
        my $total = $count{$name};
        my $return = filter ($name);
        if ( $return == 0)
        {
            # print only the words that show more than certain number times 
            printf "%-8s %s keyword = $key_word , date = $search_date \n", $name, $total if ($total > 200);
			$dbh->do("INSERT INTO term_frequency VALUES ( '$key_word', '$name', $total, '$search_date')") if ($total > 200);
        }
    }
}
	
#foreach my $str (sort keys %count) 
#printf "%-31s %s\n", $str, $count{$str};
#}