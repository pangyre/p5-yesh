package Yesh::Controller::Tag;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Yesh::Controller::Tag - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Yesh::Controller::Tag in Tag.');
}


=head1 AUTHOR

apv

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
