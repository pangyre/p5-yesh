package Yesh::Test;
use parent qw( Test::Class );
use Moose;
BEGIN { $ENV{YESH_CONFIG_LOCAL_SUFFIX} ||= "test" }

no Moose;

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

__END__

=pod

=head1 NAME

Yesh::Test - L<Test::Class> subclass to use as master for all tests.

=head1 SYNOPSIS

 # something...

=head1 COPYRIGHT AND LICENSE

See L<Yesh>.

=cut


  TODO: { "Currently unimplemented" };

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
    writer => "_mech",
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
#    eval q{ use Catalyst::Test "Yesh"; 1; }
#        or BAIL_OUT($@ || "...don't know why...");
#    my ( $res, $c ) = ctx_request("/");
#    $self->_c($c);
    1;
}

# No! This should be elsewhere if at all.
# sub test_sanity : Tests { isa_ok( +shift->mech, "Test::WWW::Mechanize::Catalyst" ); }

# __PACKAGE__->meta->make_immutable;

sub config {
    {
        local_suffix => "setup",
        is_test_config => 1,
        sqlite_form => {
                        db_name => 'yesh_test',
                        password => undef,
                        user => undef,
                        port => undef,
                        dbd => 'SQLite',
                        host => 'localhost'
                       },
        admin_data => {
                       email => 'fluffy@example.com',
                       password2 => 'S00p3rs3Kr372',
                       password => 'S00p3rs3Kr372',
                       email2 => 'fluffy@example.com',
                       username => 'Ashley'
                      },
        postgres_form => {
                          db_name => 'yesh_test',
                          password => undef,
                          user => undef,
                          port => undef,
                          dbd => 'Pg',
                          host => 'localhost'
                         },
         mysql_form => {
                       db_name => 'yesh_test',
                       password => undef,
                       user => undef,
                       port => undef,
                       dbd => 'mysql',
                       host => 'localhost'
                      }
  };
}

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
