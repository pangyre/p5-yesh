#!/usr/bin/env perl
use strict;
use warnings;
use Test::More "no_plan";
use File::Temp qw/ tempfile /;

use FindBin;
use lib "$FindBin::Bin/lib";
use Yesh::Schema;

my ( $fh, $filename ) = tempfile(SUFFIX => ".sqlite",
                                 EXLOCK => 0);

# my $filename = "./ab"; unlink $filename;

my $dsn = "dbi:SQLite:$filename";

ok( my $schema = Yesh::Schema->connect($dsn,
                                       undef,
                                       undef,
                                       { AutoCommit => 1,
                                         RaiseError => 1 }),
    "Connected to Yesh::Schema -> $dsn" );

$schema->deploy();

ok( my $user_rs = $schema->resultset("User"),
    "User result set" );

is( 0, $user_rs->search->count,
    "No users in fresh DB" );

for my $u ( qw( one two three ) )
{
    ok( $user_rs->create({
        username => $u,
        email => join('@', $u, "$u.$u"),

                         }),
        "Creating a user: $u"
       );
}

is( 3, $user_rs->search->count,
    "Three users now in DB" );


__END__

# use YAML; die Dump($schema);

$schema->deploy();
#                 quote_char => "`",
#                 quote_field_names => 1,
#                 quote_table_names => 1,
#                });
