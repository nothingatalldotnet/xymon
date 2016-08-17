#!/usr/bin/perl -w

use strict;
use warnings;

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use JSON;
use Getopt::Std;

my $posturl = "";
my $server = $ENV{'BBHOSTNAME'};
my $color = $ENV{'BBCOLORLEVEL'};
my $recovered = $ENV{'RECOVERED'};
my $msg = $ENV{'BBALPHAMSG'};
my $emoji = "";
my $hexcolor = "";
my $at = "";

if ($recovered eq "1") {
	$hexcolor = "#00ff00";
	$emoji = ":green_heart:";
} else {
	if ($color eq "red") {
		$emoji = ":broken_heart:";
		$hexcolor = "#ff0000";
		$at = "\@channel";
	} elsif ($color eq "yellow") {
		$emoji = ":yellow_heart:";
		$hexcolor = "#ffff00";
	} elsif ($color eq "purple") {
		$hexcolor = "#bf00ff";
		$emoji = ":purple_heart:";
	} elsif ($color eq "green") {
		$hexcolor = "#00ff00";
		$emoji = ":green_heart:";
	} else {
		$hexcolor = "#808080";
		$emoji = ":ghost:";
	}
}

my $payload = {
	as_user => 'false',
	channel => 'xymon',
	username => 'xymonbot',
	icon_emoji => $emoji,
	attachments => [{
		color => $hexcolor,
		text => $msg,
		footer => "xymonlovesyou",
		footer_icon => ""
	}],
	text => $emoji." *".$server."* ".$at
};

my $ua = LWP::UserAgent->new;
$ua->timeout(15);

my $req = POST("${posturl}", ['payload' => encode_json($payload)]);
my $resp = $ua->request($req);

exit(0);