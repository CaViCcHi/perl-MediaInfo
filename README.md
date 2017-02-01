# perl-MediaInfo
Simple library that translates the output of "mediainfo" to comprehensive perl hash

# Usage
perl mediaperl [video_file]

# In Perl
use lib '/wherever/you/place/it';
use MediaInfo;

my $info = mediainfo $filename;

... and that's it
