BEGIN {
    $ENV{YESH_CONFIG_LOCAL_SUFFIX} = "test";
}
use strict;
use warnings;
use Test::More "no_plan";
use HTTP::Request::Common qw( GET POST PUT );

use Catalyst::Test 'Yesh';

my ( $res, $c ) = ctx_request("/");
is( $res->code, 200, "/");

eval {
    my @connection = @{ $c->config->{"Model::DBIC"}->{connect_info} };
    my ( $file ) = $connection[0] =~ /SQLite:(.+)/;
    unlink $file;
    my $schema = $c->model("DBIC")->schema;
    $schema->deploy();
    1;
} || die $@;

is( request("/no-such-resource")->code, 404, "A known 404");

is( request("/article")->code, 200, "/article" );

is( request("/user")->code, 200, "/user" );

like( request("/user")->decoded_content,
      qr/No users/i,
      "No users to display" );

is( request("/tag")->code, 200, "/tag" );

is( request("/login")->code, 200, "/login" );

{
    my $response = request POST '/user',
        [
         username => "ashley",
         password => "S00p3rs3Kr37",
         password2 => "S00p3rs3Kr372",
         email => 'fluffy@sedition.com',
        ];
    like( $response->decoded_content,
          qr/Does not match 'Email' value/i,
          "Email doesn't match" )
}

{
    my $response = request POST '/user',
        [
         password => "S00p3rs3Kr37",
         password2 => "S00p3rs3Kr37",
         email => 'fluffy@sedition.com',
         email2 => 'fluffy@sedition.com',
        ];
    like( $response->decoded_content,
          qr/This field is required/i,
          "No username gets 'This field is required'" );
}

{
    my $response = request POST '/user',
        [
         username => "ashley",
         email => 'fluffy@sedition.com',
         email2 => 'fluffy@sedition.com',
        ];
    like( $response->decoded_content,
          qr/This field is required/i,
          "No password gets 'This field is required'" );
}

{
    my $response = request POST '/user',
        [
         username => "ashley",
         password => "S00p3rs3Kr37",
         password2 => "S00p3rs3Kr37",
        ];
    like( $response->decoded_content,
          qr/This field is required/i,
          "No email gets 'This field is required'" );
}

{
    my $response = request POST '/user',
        [
         username => "ashley",
         password => "S00p3rs3Kr37",
         password2 => "S00p3rs3Kr37",
         email => 'fluffy@sedition.com',
         email2 => 'fluffy@sedition.com',
        ];
    like( $response->decoded_content,
          qr/created an account/i,
          "Created an account" );
}

like( request("/user")->decoded_content,
      qr/ashley/,
      "User content looks good" );
