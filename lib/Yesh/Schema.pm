package Yesh::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-03-14 13:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BTx7LG11FWCiil9vOhnXCw

our $VERSION = "3.00";

1;

__END__

sub connection {
    my $self = +shift->SUPER::connection(@_);
    if ( $self->storage->sqlt_type eq "SQLite" )
    {
        require Date::Calc;
        my $now = sub {
            sprintf('%d-%02d-%02d %02d:%02d:%02d',
                    Date::Calc::Today_and_Now());
        };
#        $self->storage->dbh->sqlite_create_aggregate("NOW", 0, $now);
$self->storage->dbh->func("NOW",
          0,
           sub { sprintf('%d-%02d-%02d %02d:%02d:%02d', Date::Calc::Today_and_Now()) },
           "create_aggregate");

    }
    return $self;
}


    use Date::Calc;

$dbh->func("NOW",
          0,
           sub { sprintf('%d-%02d-%02d %02d:%02d:%02d', Date::Calc::Today_and_Now) },
           "create_aggregate");


$dbh->sqlite_create_function( $name, $argc, $code_ref )

my $now = sub { sprintf('%d-%02d-%02d %02d:%02d:%02d', Date::Calc::Today_and_Now) };
$dbh->sqlite_create_function("NOW", 0, $now);