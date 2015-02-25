#!/usr/bin/perl 
use English;
use Data::Dumper;
use Time::Local;
use File::Basename;
use File::Path;
use XML::Simple;
use Cwd;
use POSIX('mktime');
use File::Copy;

#use strict;
use warnings;

use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;


##open file to store links
open my $file1,">>", ("extracted_links.txt");
select($file1); 

##starting URL
my @urls = 'http://www.bing.com/search?q=iphone';

my $browser = LWP::UserAgent->new('IE 6');
$browser->timeout(10);
my %visited;
my $url_count = 0;


while (@urls) 
{
     my $url = shift @urls;
     if (exists $visited{$url}) ##check if URL already exists
     {
         next;
     }
     else
     {
         $url_count++;
     }         

     my $request = HTTP::Request->new(GET => $url);
     my $response = $browser->request($request);

     if ($response->is_error()) 
     {
         printf "%s\n", $response->status_line;
     }
     else
     {
         my $contents = $response->content();
         $visited{$url} = 1;
         my @lines = split(/\n/,$contents);
		 my $line;
         foreach $line(@lines)
         {
			#print "line = $line \n";
             $line =~ m@(((http\:\/\/)|(www\.))([a-z]|[A-Z]|[0-9]|[/.]|[~]|[-_]|[()])*[^'">])@g;
             if ($1){ print "$1\n"; } 
			 
             push @urls, $$line[2];
         }

         sleep 60;

         if ($visited{$url} == 100)
         {
            last;
         }
    }
}

close $file1;