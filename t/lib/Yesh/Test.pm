package Yesh::Test;
use parent qw( Test::Class );
use Moose;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use Catalyst::Test;

has "mech" =>
    isa => "Test::WWW::Mechanize::Catalyst",
    is => "ro",
    required => 1,
    writer => "_mech",
    lazy => 1,
    default => sub { Test::WWW::Mechanize::Catalyst->new(catalyst_app => "Yesh") },
    ;

BEGIN {
    $ENV{YESH_CONFIG_LOCAL_SUFFIX} ||= "test";

    eval q{ use Catalyst::Test "Yesh"; 1; }
        or BAIL_OUT($@||"...don't know why...");

    # Dummy, it's already in here *Yesh::Test::ctx_request = sub { ctx_request(@_) };

    my ( $res, $c ) = ctx_request("/");
    $c->config->{is_test_config}
        or BAIL_OUT("This does not appear to be the test configuration!");
}

sub _setup : Test(startup) {
    my $self = shift;

    # Maybe do the deployment here...? Why would we want to test
    # set-up every time? Maybe then this could just be run with the
    # suffix to set which DB to deploy too?
    1;
}

# No! This should be elsewhere if at all.
#sub test_sanity : Tests { isa_ok( +shift->mech, "Test::WWW::Mechanize::Catalyst" ); }

# __PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

perl -Ilib -It/lib -MYesh::Test -le "Yesh::Test->runtests"

my @connection = @{ $c->config->{"Model::DBIC"}->{connect_info} };
my ( $file ) = $connection[0] =~ /SQLite:(.+)/;
my $schema = $c->model("DBIC")->schema;
$schema->deploy();
1;

use utf8;
my $korean = "닛곰다가 살ㅂ고사서";