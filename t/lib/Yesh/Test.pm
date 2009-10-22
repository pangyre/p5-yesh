package Yesh::Test;
use parent qw(Test::Class);
use Moose;
use warnings;
use strict;
use Test::More;
use Test::WWW::Mechanize::Catalyst;

has "mech" =>
    isa => "Test::WWW::Mechanize::Catalyst",
    is => "ro",
    required => 1,
    writer => "_mech"
    ;

sub setup : Test(startup) {
    my $self = shift;
    $ENV{YESH_CONFIG_LOCAL_SUFFIX} = "test";
    $self->_mech( Test::WWW::Mechanize::Catalyst->new(catalyst_app => "Yesh") );
    eval q| use Catalyst::Test "Yesh"; |;
    *Yesh::Test::ctx_request = *ctx_request;
    my ( $res, $c ) = ctx_request("/");
    $c->config->{is_test_config} or BAIL_OUT("This does not appear to be the test configuration!");
}

sub test_sanity : Tests {
    isa_ok( +shift->mech, "Test::WWW::Mechanize::Catalyst" );
}

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
