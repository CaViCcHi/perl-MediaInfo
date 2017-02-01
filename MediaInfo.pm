package MediaInfo;

$VERSION = "0.1";

require 5.004;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(mediainfo);

use warnings;
use strict;

our $med = '/usr/bin/mediainfo';
our @sections = qw(General Video Audio Text Menu);

sub mediainfo (;$)
{
	my $filein = shift;

	if(!-f $filein)
	{
		die("I couldn't find the file $filein, come on dude... get your shit together...\n");
	}
	my @in = `$med $filein`;
	if($?)
	{
		die("Something horrible might have happened, I'm not here... we never spoke...\n");
	}
	chomp @in;

	# The Key
	my $dawn;
	my $info = {};
	my $matrix = {};
	foreach my $row (@in)
	{
		next if($row =~ m/^\s*$/);
		if($row =~ m/:/) # Value
		{
			if($row =~ m/^(.{2,41}?)\s{1,}:\s(.{1,})$/)
			{
				my $l = $1;
				my $r = $2;
				chomp $l;
				chomp $r;
	
				$l = lc $l;
				$l =~ s/[^a-zA-Z0-9_\:]/_/g;
	
				$matrix->{$l} = $r;
			}
		}
		elsif($row =~ m/^[a-zA-Z]{1,}\s*/) # Key
		{
			if(scalar keys %$matrix)
			{
				push(@{$info->{$dawn}->{list}}, $matrix);
				$matrix = {};
			}
	
			if($row =~ m/^([a-zA-Z]{1,}).*$/)
			{
				chomp $1;
				if(!($1 ~~ @sections))
				{
					 print STDERR "Something to learn here... Title:$1";
				}
				$dawn = lc $1;
				if(!exists($info->{$dawn}))
				{
					$info->{$dawn}->{list} = [];
					$info->{$dawn}->{count} = 1;
				}
				else
				{
					$info->{$dawn}->{count} += 1;
				}
			}
		}
	}

	if(scalar keys %$matrix)
	{
		push(@{$info->{$dawn}->{list}}, $matrix);
		$matrix = {};
	}

return $info;
}

# Inspiration by The Goonies...

1;
