use strict;
use warnings;
use Test::More "no_plan";
use HTTP::Request::Common qw( GET POST PUT );

use Catalyst::Test 'Yesh';

is( request("/")->code, 200, "/");
is( request("/no-such-resource")->code, 404, "A known 404");

is( request("/article")->code, 200, "/article" );

is( request("/user")->code, 200, "/user" );

is( request("/tag")->code, 200, "/tag" );

is( request("/login")->code, 200, "/login" );

{
    my $response = request POST '/user',
        [
         bar => 'baz',
         something => 'else'
        ];

}
