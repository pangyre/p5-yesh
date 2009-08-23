#BEGIN {
#    $ENV{YESH_CONFIG_LOCAL_SUFFIX} = "test_setup";
#}
use strict;
use warnings;
use Test::More "no_plan";
use Test::WWW::Mechanize::Catalyst;
use Catalyst::Test "Yesh"; # <-- to reset test DB.

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => "Yesh");

$mech->get_ok("/", "Get /");

$mech->content_contains("Your site is not configured");

$mech->submit_form_ok({ with_fields => {
                                        auto => 1,
                                       }
                      },
                      "Submitting auto-deploy option");

__END__

is( 200, $mech->status,
    "..." );


is( my $mech->uri->path, "/
    "Form redirects" );

is( $mech->get("/no-such-resource")->code, 404,
    "A known 404");

$mech->get_ok("/article", "/article" );

$mech->get_ok("/user", "/user");

$mech->content_like( qr/No users/i,
                     "No users to display" );

$mech->get_ok("/tag", "/tag" );

$mech->post_ok("/user",
               [
                username => "ashley",
                password => "S00p3rs3Kr37",
                password2 => "S00p3rs3Kr372",
                email => 'fluffy@sedition.com',
               ]);

$mech->content_like(
      qr/Does not match 'Email' value/i,
      "Email doesn't match" );

$mech->post_ok("/user",
               [
                password => "S00p3rs3Kr37",
                password2 => "S00p3rs3Kr37",
                email => 'fluffy@sedition.com',
                email2 => 'fluffy@sedition.com',
               ]);

$mech->content_like(
      qr/This field is required/i,
      "No username gets 'This field is required'" );

$mech->post_ok("/user",
               [
                username => "ashley",
                email => 'fluffy@sedition.com',
                email2 => 'fluffy@sedition.com',
               ]);

$mech->content_like(
      qr/This field is required/i,
      "No password gets 'This field is required'" );

$mech->post_ok("/user",
               [
                username => "ashley",
                password => "S00p3rs3Kr37",
                password2 => "S00p3rs3Kr37",
               ]);
$mech->content_like(
      qr/This field is required/i,
      "No email gets 'This field is required'" );



$mech->post_ok("/user",
               [
                username => "ashley",
                password => "S00p3rs3Kr37",
                password2 => "S00p3rs3Kr37",
                email => 'fluffy@sedition.com',
                email2 => 'fluffy@sedition.com',
               ]);
$mech->content_like(
      qr/created an account/i,
      "Created an account" );


$mech->get("/user");
$mech->content_like( qr/\bashley\b/,
                     "/user content looks good" );

$mech->get("/");
$mech->content_unlike( qr/\bashley\b/,
                       "User is not mentioned on home page" );

$mech->follow_link_ok({ text_regex => qr/sign.in/i },
                        "Following sign-in link" );

is( $mech->uri->path, "/login", "Landed on /login" );

$mech->get("/login?username=ashley;password=S00p3rs3Kr37");

$mech->content_unlike( qr/successful/i,
                       "Login via GET fails" );

$mech->post_ok("/login",
               [
                username => "ashley",
                password => "S00p3rs3Kr37",
               ],
              "Post to login");

$mech->content_like(
      qr/oh hai, ashley/i,
      "Login succeeded" );

is($mech->uri->path, "/", "Redirected to /");

$mech->content_like(qr/(?:sign|log).out/i,
                    "Sign-out link is present");

$mech->get_ok("/logout", "/logout");

$mech->content_unlike(
                      qr/\bashley\b/i,
                      "Logout succeeds" );

is($mech->uri->path, "/", "Redirected to /");

$mech->post_ok("/user",
               [
                username => "ashley",
                password => "S00p3rs3Kr37",
                password2 => "S00p3rs3Kr37",
                email => 'nope@sedition.com',
                email2 => 'nope@sedition.com',
               ],
              "Post duplicate username to /user");

$mech->content_like(
      qr/username is already in use/i,
      "Duplicate username registration fails" );

$mech->post_ok("/user",
               [
                username => "smashley",
                password => "S00p3rs3Kr37",
                password2 => "S00p3rs3Kr37",
                email => 'fluffy@sedition.com',
                email2 => 'fluffy@sedition.com',
               ],
              "Post duplicate email to /user");

$mech->content_like(
                    qr/email address is registered .+? already/i,
                    "Duplicate email registration fails" );

{
    $mech->post_ok("/user", [ x => 1 ],
                   "Nothing filled out in POST to /user");
    my $slash_user = $mech->content;

    $mech->post_ok("/user/register", [ x => 1 ],
                   "Nothing filled out in POST to /user/register");
    my $slash_user_register = $mech->content;

    $mech->content_like(qr/field is required/i,
                        "Missing fields feedback");
    # diag($mech->content);
    is( $slash_user, $slash_user_register,
        "POST results to /user and /user/register are equivalent");
}

