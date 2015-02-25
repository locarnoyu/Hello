#!/usr/bin/perl 
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

# log product file
#    my $simple = XML::Simple->new();
#    my $data   = $simple->XMLin($product_tgt_file);

    #print Dumper($data) . "\n";

#    foreach my $dep (@{$data->{Dependency}}){
#    	print $dep->{Name} . "\n";#
#	    CheckDep ($dep->{Name});
#    }


#recursive spider web starting from a page and
#specifying depth level
#like wget -r --level=...
my $filename;
my $google_link = "\"http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=iphone&start=4\"";
## google http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=iphone&start=4 
## bing http://www.bing.com/search?q=iphone&qs=n&pq=iphone&sc=8-6&sp=-1&sk=&cvid=a9bde99dc99443568e2449defa43aeb9&first=9&FORM=PERE

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
#my ($depth_level,$start_page, $search_engine) = @ARGV;
#print "1 = $depth_level,2 = $start_page,3 = $search_engine \n";
#exit 1 unless $start_page;#exits if it doesn't have a parameter page to download

#my $root = "C:\\data\\20150211\\iphone\\";
#my $filename = $root.$start_page.".xml";

#if( !defined $depth_level || $depth_level > 0 ) {
   # my $page_content=`curl $start_page 2>&1`;
   my $cur_link = "\"http://www.google.ca/?gfe_rd=cr&ei=zrzbVLnwHquC8QeL2YCgDA&gws_rd=ssl#q=iphone\"";
	my $page_content;
	open my $fh,"curl $google_link|";
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


        use Data::Dumper;
        print Dumper( $page_content );
		
	
	    #my $simple = XML::Simple->new();
    #my $data   = $simple->XMLin($filename);

    #print Dumper($data) . "\n";

    #foreach my $dep (@{$data->{url}}){
   # 	print $dep->{Name} . "\n";#
#	    CheckDep ($dep->{Name});
    #}


	
	#        open FH, ">>$filename" or die "can't open '$filename': $!";
#            print FH $page_content;
#        close FH;
	print "page_content = $page_content \n";
	#<a href="http://www.dailymail.co.uk/sciencetech/article-2947674/Apple-s-iPhone-6-Plus-generates-DOUBLE-data-iPhone-6-ten-times-3GS.html" 
	#<a href="http://www.dailymail.co.uk/sciencetech/article-2947674/Apple-s-iPhone-6-Plus-generates-DOUBLE-data-iPhone-6-ten-times-3GS.html" target="_blank" h="ID=news,5025.1">
    my @links = ($page_content =~ /<a href=([^>]*?)>/g);#takes out the links from the page
#	while( $page_content =~ m/<a[^>]*?href=\"([^>]*?)\"[^>]*?>\s*([\w\W]*?)\s*<\/a>/igs )
#{   
#my $link = $1;

#if ($link =~ "bing" || $link =~ "microsoft.com")
#{
#;;
#}
#elsif ( $link =~ "http") 
#{
#print "Link:$link \n";
#}

    #print "Link:$1 \t Text: $2\n";
#}
	#my $link;
	#while ($link =~ /<a href=(.*?)>/g)
	#{
	#	print $1. "\n";
	#}
	#my @links = $page_content =~ /<a href=([^ ]*?)>/g;#takes out the links from the page
	my $count =0 ;
	my @array;
    foreach(@links) {
	
		if ($_ =~ "^\"http"){
		   
				$count++;
				my ($link, $rest) = split (" ", $_);
				substr($link, 0, 1) = "" ;
				chop ($link);
				#print "Working on link $count = $link\n";
				push (@array, $link);
			
		}
 #       my $new_call = "perl naive_crawler.pl ". ($depth_level - 1) ."+ $_";#new call for the script with the links from the page
 #       `$new_call`;
    };
	my %hash = map { $_ => 1 } @array;
    my @unique = keys %hash;
	foreach ( @unique )
        {
            print  $_ . "\n";
			
			my $local_link = "\"".$_."\"";
			
			open my $fh,"curl $_|";
                {
                        local $/;
                        $page_content=<$fh>;
                }
                close $fh;
				
			if ($page_content)
			{
				my $filename = nextfile();
				print "file name = $filename \n";
				open( BUILDSFILE, "> $filename" ) || die "Cannot open $filename";
				print  BUILDSFILE $page_content ;
				close( BUILDSFILE );
				add_new ( $filename, $cur_link);
			}
			
			
            #my $new_call = "perl test.pl ". ($depth_level - 1) ."+ $_". " $search_engine";#new call for the script with the links from the page
            #`$new_call`;
 			
        }
        
	
#}
