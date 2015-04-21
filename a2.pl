use strict;
use warnings;
use Cwd;
use List::MoreUtils 'any';
use DBI;
use File::Stat;

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}


my $key_word = "googlenexus";
my $dbh = DBI->connect("DBI:mysql:database=research;host=localhost",
 "wyu", "q1w2..AS",
 {'RaiseError' => 1});
my $sth = $dbh->prepare("SELECT * FROM term_frequency where key_word=\"$key_word\"");
$sth->execute;
my $numRows = $sth->rows;
my $numFields = $sth->{'NUM_OF_FIELDS'};

# HTML TABLE
#print "<table border='1'><tr>
#<th>id</th>
#<th>product</th>
#<th>quantity</th>
#<th>size</th></tr>";

# FETCHROW ARRAY
my @results;
my %link_size = ();
my %link_weight = ();
my @terms;
while (@results = $sth->fetchrow()) {
		push(@terms, $results[1]);
}

#print "</table>";
$sth->finish;

my @filtered = uniq(@terms);

print "Size: ",scalar @filtered,"\n";

#print "@filtered\n";
foreach (@filtered) {
 	my $term =  $_ ;
	
	$sth = $dbh->prepare("SELECT * FROM term_frequency where key_word=\"$key_word\" and term=\"$term\"");
    $sth->execute;
	$numRows = $sth->rows;
	my $size;
	my $total_size= 0;
	while (@results = $sth->fetchrow()) {
		#print "data = $results[1] ,"  . "\n" . "link = $results[2] ," . "\n" . "size = $results[3] \n" ;
		   $total_size = $total_size + $results[2];
    }
	print "term = $term, "."\n". "number of results = $numRows "."\n"."total term_frequency = $total_size \n";
	$link_weight {$term}= $total_size;
    $sth->finish;
} 
#print "rows =$numRows, fields =$numFields \n ";
print "size of hash:  " . keys( %link_weight ) . ".\n";
#foreach my $weight (sort values %link_weight) {
#    print "$weight \n";
#}

my %key_tf =();
my $term_to_use = 20;
my $low_term;
foreach my $name (sort { $link_weight{$b} <=> $link_weight{$a} } keys %link_weight) {
    #printf "%-8s %s\n", $name, $link_weight{$name};
	if ( $term_to_use > 0 )
	{
		$term_to_use--;
		$key_tf {$name} = $link_weight{$name};
		$low_term = $link_weight{$name};
	}
}

my %term_weight =();

foreach my $name (sort { $key_tf{$b} <=> $key_tf{$a} } keys %key_tf) {
printf "%-8s %s\n", $name, $key_tf{$name};
my $weight = $key_tf{$name}/$low_term;
$term_weight {$name} = $weight;
}

foreach my $name (sort { $term_weight{$b} <=> $term_weight{$a} } keys %term_weight) {
printf "%-8s %s\n", $name, $term_weight{$name};
}
 
$dbh->disconnect();
