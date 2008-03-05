#!perl

use strict;
use warnings;
use Test::More tests => 12;

BEGIN { use_ok( 'WWW::Curl::Easy' ); }

my $url = $ENV{CURL_TEST_URL} || "http://www.google.com";

# Init the curl session
my $curl = WWW::Curl::Easy->new();
ok($curl, 'Curl session initialize returns something');
ok(ref($curl) eq 'WWW::Curl::Easy', 'Curl session looks like an object from the WWW::Curl::Easy module');

ok(! $curl->setopt(CURLOPT_NOPROGRESS, 1), "Setting CURLOPT_NOPROGRESS");
ok(! $curl->setopt(CURLOPT_FOLLOWLOCATION, 1), "Setting CURLOPT_FOLLOWLOCATION");
ok(! $curl->setopt(CURLOPT_TIMEOUT, 30), "Setting CURLOPT_TIMEOUT");

open (HEAD, "+>", undef);
ok(! $curl->setopt(CURLOPT_WRITEHEADER, *HEAD), "Setting CURLOPT_WRITEHEADER");

open (BODY, "+>", undef);
ok(! $curl->setopt(CURLOPT_FILE,*BODY), "Setting CURLOPT_FILE");

ok(! $curl->setopt(CURLOPT_URL, $url), "Setting CURLOPT_URL");

open (NEW_ERROR,"+>", undef);
ok(! $curl->setopt(CURLOPT_STDERR, *NEW_ERROR), "Setting CURLOPT_STDERR");

# create a (hopefully) bad URL, so we get an error

ok(! $curl->setopt(CURLOPT_URL, "badprotocol://127.0.0.1:2"), "Setting CURLOPT_URL succeeds, even with a bad protocol");

my $retcode = $curl->perform();

ok($retcode, "Non-zero return code indicates the expected failure");

exit;
