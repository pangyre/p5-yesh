BEGIN {
    $ENV{YESH_CONFIG_LOCAL_SUFFIX} = "test";
}
use strict;
use warnings;
use Test::More skip_all => "Nothing written";
use HTTP::Request::Common qw( GET POST PUT );

use Catalyst::Test 'Yesh';


__END__


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

unlike( request("/")->decoded_content,
        qr/\bashley\b/,
        "User is mentioned on home page" );

is( request("/login")->code, 200, "/login" );

{
    my $response = request GET '/login',
        [
         username => "ashley",
         password => "S00p3rs3Kr37",
        ];
    unlike( $response->decoded_content,
            qr/successful/i,
            "Login via GET fails" );
}

{
    my $response = request POST '/login',
        [
         username => "ashley",
         password => "S00p3rs3Kr37",
        ];
    is( $response->code, 302,
        "Login redirects" );

    $response = request('/');

    like( $response->decoded_content,
          qr/oh hai, ashley/i,
          "Login succeeded" );
#    like( $response->base->path, "/",
#          "Landed on / after login" );
}

{
    my $response = request('/logout');
    like( $response->decoded_content,
          qr/signed out/i,
          "Logout succeeds" );
#    like( $response->uri->path, "/",
#          "Landed on / after logout" );
}

{
    my $response = request POST '/user',
        [
         username => "ashley",
         password => "S00p3rs3Kr37",
         password2 => "S00p3rs3Kr37",
         email => 'nope@sedition.com',
         email2 => 'nope@sedition.com',
        ];
    like( $response->decoded_content,
          qr/username is already in use/i,
          "Duplicate username registration fails" );
}


{
    my $response = request POST '/user',
        [
         username => "smashley",
         password => "S00p3rs3Kr37",
         password2 => "S00p3rs3Kr37",
         email => 'fluffy@sedition.com',
         email2 => 'fluffy@sedition.com',
        ];
    like( $response->decoded_content,
          qr/email address is registered .+? already/i,
          "Duplicate email registration fails" );
}
