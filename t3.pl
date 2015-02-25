#!/usr/bin/perl

my $url = "http://www.google.ca/?gfe_rd=cr&ei=zrzbVLnwHquC8QeL2YCgDA&gws_rd=ssl#q=iphone";

# Load our modules
# Please note that you MUST have LWP::UserAgent and JSON installed to use this
# You can get both from CPAN.
use LWP::UserAgent;
use JSON;

# Initialize the UserAgent object and send the request.
# Notice that referer is set manually to a URL string.
my $ua = LWP::UserAgent->new();
$ua->default_header("HTTP_REFERER" => "http://www.google.ca/?gfe_rd=cr&ei=zrzbVLnwHquC8QeL2YCgDA&gws_rd=ssl#q=iphone");
my $body = $ua->get($url);
        use Data::Dumper;
        print Dumper( $body );

# process the json string
my $json = from_json($body->decoded_content);
