package Yesh::Schema::ResultSet::Article;
use strict;
use warnings;
use parent "DBIx::Class::ResultSet";

sub live {
    +shift->search({ %{+shift || {}},
                     status   => 'publish',
                     takedown => \" > NOW()",
                     golive   => \" < NOW()",
                    },
                   { order_by => 'golive DESC',
                     %{+shift || {}},
                    });
}

sub live_rs { scalar +shift->live(@_); }

1;

