package Yesh::Schema::ResultSet::Article;
use strict;
use warnings;
use parent "DBIx::Class::ResultSet";
use Date::Calc qw( Today_and_Now );

sub live {
    my $now = sprintf('%d-%02d-%02d %02d:%02d:%02d',
                      Today_and_Now());
    +shift->search({ %{+shift || {}},
                     status   => 'publish',
                     takedown => { ">" => $now },
                     golive => { "<=" => $now },
                    },
                   { order_by => 'golive DESC',
                     %{+shift || {}},
                    });
}

sub live_rs { scalar +shift->live(@_); }

1;

