package Yesh::Schema::ResultSet::Article;
use strict;
use warnings;
use parent "DBIx::Class::ResultSet";
#use Date::Calc qw( Today_and_Now );
#use DateTime;

sub _formatter {
    my $self = shift;
    return $self->{_datetime_parser} if $self->{_datetime_parser};
    $self->{_datetime_parser} = $self->result_source->schema->storage->datetime_parser;
}

# It would be nice to cache this in instance data so that is_live can
# be short circuited if the record came from here...?
sub live {
    my $self = shift;
#    my $now = sprintf("%d-%02d-%02d %02d:%02d:%02d",
#                      Today_and_Now());
    #use YAML;    die $DATETIME_FORMATTER;
    my $now = DateTime->now(formatter => $self->_formatter);

    $self->search({ %{+shift || {}},
                    status   => "publish",
                    takedown => { ">" => $now },
                    golive => { "<=" => $now },
                  },
                  { order_by => "golive DESC",
                    %{+shift || {}},
                  });
}

sub not_live {
    my $self = shift;
    my $now = DateTime->now(formatter => $self->_formatter);

    $self->search({ %{+shift || {}},
                    -or => [
                            status   => { "!=" => "publish" },
                            takedown => { "<" => $now },
                            golive => { ">=" => $now },
                            ]
                  },
                  { order_by => "golive DESC",
                    %{+shift || {}},
                  });
}

sub live_rs { scalar +shift->live(@_); }
sub not_live_rs { scalar +shift->not_live(@_); }

1;

__END__

=head1 NAME

Yesh::Schema::ResultSet::Article - extensions to using L<Yesh::Schema::Result::Article>.

=head1 METHODS

=over 4

=item live

Searches articles which match criteria to be called "live." Namely they have a status of C<publish> and have a C<golive> of now or earlier and a C<takedown> sometime in the future. Orders results by C<golive DESC>.

Accepts serach attributes other than status, takedown, and golive. Accepts any additional attributes including C<order_by> to override the default.

=item live_rs

L</live> guaranteed to return a result set.

=back

=head1 LICENSE, AUTHOR, COPYRIGHT, SEE ALSO

L<Yesh::Manual>.

=cut
