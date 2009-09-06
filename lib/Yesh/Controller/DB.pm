package Yesh::Controller::DB;
use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Matched Yesh::Controller::DB in DB.');
}

sub schema : Local Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( schema => $c->model("DBIC")->schema );
}

1;

__END__

=head1 NAME

Yesh::Controller::DB - Catalyst Controller

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
