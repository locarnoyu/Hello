#!/usr/bin/perl

# Load our modules
# Please note that you MUST have LWP::UserAgent and JSON installed to use this
# You can get both from CPAN.
use LWP::UserAgent;
use JSON;
use strict;
use warnings;
use English;
use Data::Dumper;
use Time::Local;
use File::Basename;
use File::Path;
use XML::Simple;
use Cwd;
use POSIX('mktime');
use File::Copy;

# Initialize the UserAgent object and send the request.
# Notice that referer is set manually to a URL string.
#my $ua = LWP::UserAgent->new();
#$ua->default_header("HTTP_REFERER" => "http://yahoo.com");

my @array;

sub nextfile ()
{
    my $filename;
    my $link;
    open( BUILDSFILE, "<version.txt" ) || die "Cannot open version.txt";
    foreach my $line( <BUILDSFILE> )
    {
        if( $line =~ /^(\d+)\t(\S+)/ )
        {
            $filename= $1;
            $link = $2;
        }
    }
    close( BUILDSFILE );
    $filename++;
    print "new filename = $filename \n";
    return $filename++;
}
sub add_new ( $$)
{
    my ($newfile, $newlink) = @_;
    my $new_line = join ("	", $newfile, $newlink);

    open( BUILDSFILE, ">> version.txt" ) || die "Cannot open version.txt";
    print  BUILDSFILE "\n".$new_line ;
    close( BUILDSFILE );
}

sub download ($)
{
 my ($cur_link) = @_;

 print "download link is $cur_link \n";
	my $page_content;
	my $filename;
	open my $fh,"curl -k $cur_link|";
                {
                        local $/;
                        $page_content=<$fh>;
                }
                close $fh;
				
	if ($page_content)
	{
		$filename = nextfile();
		print "file name = $filename \n";
		open( BUILDSFILE, "> $filename" ) || die "Cannot open $filename";
		#print  BUILDSFILE $page_content ;
		close( BUILDSFILE );
		add_new ( $filename, $cur_link);
	}
	if ($filename)
	{
       open FH, ">>$filename" or die "can't open '$filename': $!";
       print FH $page_content;
       close FH;
	}

}

# collect top 100 google search results

my $number_loop;
my $i = 0;
my $keyword="google%40nexus";
for (my $number_loop=0; $number_loop <= 16; $number_loop++) {
    sleep 60;
    my $mul = $number_loop * 4;
    my $cur_link = my $google_link = "\"http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=$keyword&start=$mul\"";
	print "google link is = $cur_link \n";
	my $page_content;
	open my $fh,"curl -k $cur_link|";
                {
                        local $/;
                        $page_content=<$fh>;
                }
                close $fh;
		


    my $json = decode_json($page_content);
    # have some fun with the results

        foreach my $result (@{$json->{responseData}->{results}}){
        $i++;
        #print $i.". " . $result->{titleNoFormatting} . "(" . $result->{url} . ")\n";
		print $result->{url} . "\n";
		push (@array, $result->{url});
        # etc....
    }
    if(!$i){
           print "Sorry, but there were no results.\n";
    }
}
foreach (@array) {
 	download ($_);
} 