#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 4;

BEGIN { use_ok 'Catalyst::Test', 'Yesh' }

ok( ! request('/')->is_success, '/ should not succeed' );
ok( request('/')->is_redirect, '/ should redirect' );
ok( request('/setup')->is_success, '/setup should ' );


