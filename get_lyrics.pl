#!/usr/bin/perl

use strict;
use warnings;

use LWP::UserAgent ();
use HTML::TreeBuilder ();
use HTML::FormatText ();

my $ua = LWP::UserAgent->new;
$ua->agent("Genius Scraper");

print "Name of the band/singer: ";
my $band = <STDIN>;
print "Name of the song: ";
my $song = <STDIN>;

chomp($band);
chomp($song);

$band =~ s/\s+/-/;
$song =~ s/\s+/-/;

my $url = "https://genius.com/$band-$song-lyrics";
print "Currently looking at: $url\n";
my $root = HTML::TreeBuilder->new();
my $request = $ua->get($url) or die "Cannot contact Genius $!\n";
if ($request->is_success) {
	$root->parse($request->content);
} else {
	print "Cannot display the lyrics.\n";
};
my $data = $root->look_down(
	_tag => "div",
	id => "lyrics-root",
);

my $formatter = HTML::FormatText->new(leftmargin => 0, rightmargin =>50);

my $filename = "$band\_$song.txt";
open(FH, '>', $filename) or die $!;

print FH $formatter->format($data);

close(FH);
print "Writing to file successfully!\n";
