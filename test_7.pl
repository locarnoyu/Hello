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
	print "1 :$match_found \n";
	if ( $match_found == 0 )
	{
	print "loop 2\n";
	$match_found = grep(/^$word/i, @filter2)
	}
	print "2 :$match_found \n";
	if ( $match_found == 0)
	{
	print "loop 3\n";
	$match_found = grep(/^$word/i, @filter3)
	}
	print "3 :$match_found \n";
	return $match_found ;
}

my $name = "the";
my $found = filter  ($name);

print "return = $found \n";
if ( $found == 1)
{
	print "found \n";
}
else
{
 print "not found"
}