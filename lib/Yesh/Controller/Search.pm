package Yesh::Controller::Search;
use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Matched Yesh::Controller::Search in Search.');
}

sub search :Path Args(1) {
    my ( $self, $c, $query ) = @_;
    my $string = $c->model("DBIC")->schema->storage->dbh->quote($query);
    $string =~ s/\A'|'\z//g;
    $string =~ s/([_%'])/\\$1/g;
    $string =~ s/\A|\z/\%/g;
    $c->detach() unless length($string) > 5;
    $c->forward("/article/index");
    $c->stash->{articles} = $c->stash->{articles}
         ->search({ -or => [
                         "me.title" => { LIKE => $string },
                         "me.body" => { LIKE => $string },
                         ]
                        });
    $c->stash( template => "article/index.tt" );
}

1;

__END__
=head1 NAME

Yesh::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut



=head1 AUTHOR

apv

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
