package Test::Yesh;
use parent qw( Test::Class );
use Moose;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use Catalyst::Test;

has "mech" =>
    isa => "Test::WWW::Mechanize::Catalyst",
    is => "ro",
    required => 1,
    # writer => "_mech",
    lazy => 1,
    default => sub { Test::WWW::Mechanize::Catalyst->new(catalyst_app => "Yesh") },
    ;

has "c" =>
    isa => "Yesh",
    is => "ro",
    writer => "_c",
    ;

sub startup : Test(startup) {
    my $self = shift;
    $ENV{YESH_CONFIG_LOCAL_SUFFIX} ||= "test";
    eval q{ use Catalyst::Test "Yesh"; 1; }
        or BAIL_OUT($@ || "...don't know why...");
    my ( $res, $c ) = ctx_request("/");
    $c->config->{is_test_config}
        or BAIL_OUT("This does not appear to be the test configuration!");
    $self->_c($c);
    1;
}

# No! This should be elsewhere if at all.
# sub test_sanity : Tests { isa_ok( +shift->mech, "Test::WWW::Mechanize::Catalyst" ); }

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
