#!/usr/local/bin/perl

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
 
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

printf("Time Format - HH:MM:SS\n");
printf("%02d:%02d:%02d:%02d:%02d", $mon,$mday,$hour, $min, $sec);
system ("cp v1.txt v2.txt");
my $keyworld = "test";
my $data_folder = $mon.$mday."_".$keyworld;
system ( "mkdir $data_folder");
system ("cp *.pl $data_folder");
