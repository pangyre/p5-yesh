#!/usr/bin/env perl
use strict;
use warnings;
use Test::More "no_plan";
use File::Temp qw/ tempfile /;

use FindBin;
use lib "$FindBin::Bin/lib";
use Yesh::Schema;

my ( $fh, $filename ) = tempfile(SUFFIX => ".sqlite");

my $filename = "./ab";
unlink $filename;

my $dsn = "dbi:SQLite:$filename";

ok( my $schema = Yesh::Schema->connect($dsn,
                                       undef,
                                       undef,
                                       { AutoCommit => 1,
                                         RaiseError => 1 }),
    "Connected to Yesh::Schema -> $dsn" );

# use YAML; die Dump($schema);

$schema->deploy();
#                 quote_char => "`",
#                 quote_field_names => 1,
#                 quote_table_names => 1,
#                });

# my @users = $schema->resultset("User")->search();



diag( "User count: " . $schema->resultset("User")->search->count() );



