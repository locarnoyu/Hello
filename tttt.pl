#!/usr/bin/perl
use strict;	
use warnings;
#Now we will define variables, “links” is the list we are using. “cur_link” is the link of current page
# “var” is used to take in the page content.
my(@links,$cur_link,$var,$temp);
push(@links,"http://www.google.ca/?gfe_rd=cr&ei=trTbVNOQAaGC8Qf4xYEo&gws_rd=ssl#q=iphone");
foreach $cur_link (@links)
{
        if($cur_link=~/^http/)
        {
		print "link = $cur_link \n";
	  # in the next few lines, we run the system command “curl” and retrieve the page content
                open my $fh,"curl $cur_link|";
                {
                        local $/;
                        $var=<$fh>;
                }
                close $fh;
                print "\nCurrently Scanning -- ".$cur_link;
	 # In the next line we extract all links in the current page
	 #print "content = $var \n";
                my @p_links= $var=~/<a href=\"([^>]*?)\">/g;
				
				#my @links = ($page_content =~ /<a href=([^>]*?)>/g);#takes out the links from the page
                foreach $temp(@p_links)
                {       
                        if((!($temp=~/^http/))&&($temp=~/^\//))
                        {
			#This part of the code lets us correct internal addresses like “/index.aspx”
                                $temp=$cur_link.$temp;
                        }
		# In the next line we add the links to the main “links” list.
 push(@links,$temp);
                }
        }
}