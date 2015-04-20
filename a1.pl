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
my $sth = $dbh->prepare("SELECT * FROM link_size where key_word=\"$key_word\"");
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
my @links;
while (@results = $sth->fetchrow()) {
    if ($results[3] > 2000 ) {
	#	print "<tr><td>"
	#	.$results[0]."</td><td>"
	#	.$results[1]."</td><td>"
	#	.$results[2]."</td><td>"
	#	.$results[3]."</td></tr>"; 
		push(@links, $results[2]);
		#$link_size {$results[2]}= $results[3];
	}
}

print "</table>";
$sth->finish;

my @filtered = uniq(@links);

print "Size: ",scalar @filtered,"\n";

#print "@filtered\n";
foreach (@filtered) {
 	my $index_link =  $_ ;
	
	$sth = $dbh->prepare("SELECT * FROM link_size where key_word=\"$key_word\" and link=\"$index_link\"");
    $sth->execute;
	$numRows = $sth->rows;
	my $size_diff;
	my $size_of_previous;
	my $total_size_diff = 0;
	while (@results = $sth->fetchrow()) {
		#print "data = $results[1] ,"  . "\n" . "link = $results[2] ," . "\n" . "size = $results[3] \n" ;
		if (defined $size_of_previous)
		{
		   $size_diff = $size_of_previous/$results[3];
		   #print "size diff = $size_diff \n";
		   if ($size_diff >= 1) {
		      $size_diff--;
		   }
		   else{
		      $size_diff = 1 - $size_diff;
		   }
		   $total_size_diff = $total_size_diff + $size_diff;
		}
		$size_of_previous = $results[3];
    }
	if ($numRows != 0) {
		$total_size_diff = $total_size_diff/$numRows;
	}
	$link_weight {$index_link}= $total_size_diff;
	print "link = $index_link, "."\n". "number of links = $numRows "."\n"."size change = $total_size_diff \n";
	
    $sth->finish;
} 
 
$dbh->disconnect();
#print "rows =$numRows, fields =$numFields \n ";
print "size of hash:  " . keys( %link_weight ) . ".\n";
#foreach my $weight (sort values %link_weight) {
#    print "$weight \n";
#}
foreach my $name (sort { $link_weight{$a} <=> $link_weight{$b} } keys %link_weight) {
    printf "%-8s %s\n", $name, $link_weight{$name};
}