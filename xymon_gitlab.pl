#!/usr/bin/perl -w
#
# bb-gitlab - Git lab checks
# R Jones 2016
#
#
use strict;
use LWP::Simple;

## BB Global variables
#############################################################################

my $BBHOME      = "/usr/lib/xymon/client";
my $BB          = "/usr/lib/xymon/client/bin/xymon";
my $BBDISP      = "178.250.53.197";
my $MACHINE     = "_SOME_HOSTNAME_";
my $COLOR       = "clear";
my $MSG         = "";
my $HEAD        = "";
my $DATA        = "";
my $TESTNAME    = "gitlab";

## Main Program
#############################################################################
{
my $CACHEURL = "_GITLAB_URL_/health_check/cache?token=_GITLAB_TOKEN_";
my $DATABASEURL = "_GITLAB_URL_/health_check/database?token=_GITLAB_TOKEN_";
my $MIGRATIONSURL = "_GITLAB_URL_/health_check/migrations?token=_GITLAB_TOKEN_";
my $GITURL = "_GITLAB_URL_/health_check?token=r-_GITLAB_TOKEN_";

my $GITSTATUS = get($GITURL);

if($GITSTATUS eq "success"){
	$COLOR = "green";
	$MSG = "GitLab good";

	if(get($CACHEURL) ne "success") {
		$COLOR = "yellow";
		$MSG = "Cache errror";
	}
	if(get($DATABASEURL) ne "success") {
		$COLOR = "yellow";
		$MSG = "Database error";
	}
	if(get($MIGRATIONSURL) ne "success") {
		$COLOR = "yellow";
		$MSG = "Migration error";
	}
}
else {
	$COLOR = "red";
	$MSG = "GitLab error";
}

$MACHINE =~ s/\./,/g;
my $date = localtime;
my $cmd = "$BB $BBDISP \"status $MACHINE.$TESTNAME $COLOR $date $HEAD\n$DATA\n$MSG\"";
print $cmd;
system($cmd);
}