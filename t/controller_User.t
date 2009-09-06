use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Yesh' }
BEGIN { use_ok 'Yesh::Controller::User' }

ok( request('/user')->is_success, 'Request should succeed' );


