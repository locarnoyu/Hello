#!/usr/bin/perl

# Load our modules
# Please note that you MUST JSON installed to use this
# You can get it from CPAN.
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

# using curl to download search results
# -k option to make sure  to support https protocol  
#
#

# init
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

printf("Time Format - HH:MM:SS\n");
printf("%02d:%02d:%02d:%02d:%02d", $mon,$mday,$hour, $min, $sec);





# find next file name that being used to store web page content
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

# increase file name by one
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
		#open( BUILDSFILE, "> $filename" ) || die "Cannot open $filename";
		#print  BUILDSFILE $page_content ;
		#close( BUILDSFILE );
		add_new ( $filename, $cur_link);
	}
	if ($filename)
	{
	   my $page_name = $filename . ".html";
       open FH, ">>$page_name" or die "can't open '$page_name': $!";
       print FH $page_content;
       close FH;
	}

}

# collect top 100 google search results

my @keywords=("iphone","samsung","HTC", "motorola","googlenexus","smartwatch");

foreach ( @keywords)
{
	my $keyword = $_;
	my $number_loop;
	my $i = 0;

	my @array;
	for (my $number_loop=0; $number_loop <= 16; $number_loop++) {
		sleep 60; # to avoid google abuse detect 
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
		}
		if(!$i){
			   print "Sorry, but there were no results.\n";
		}
	}
	# init version number
	system ("cp version0.txt version.txt");

	# download links
	foreach (@array) {
		download ($_);
	} 

	# move downloaded page to 
	my $data_folder = $mon.$mday."_".$keyword;
	system ( "mkdir $data_folder");
	system ("mv *.html $data_folder");
	system ("mv version.txt $data_folder");
}
