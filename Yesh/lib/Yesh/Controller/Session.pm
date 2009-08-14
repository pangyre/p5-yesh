package Yesh::Controller::Session;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Matched Yesh::Controller::Session in Session.');
}

sub login :Global {
    my ( $self, $c ) = @_;

}

1;
