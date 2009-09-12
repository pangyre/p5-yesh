package Yesh::Controller::Admin::DB;
use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Matched Yesh::Controller::Admin::DB->index.');
}

sub schema : Local Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( schema => $c->model("DBIC")->schema );
}

1;

__END__

=head1 NAME

Yesh::Controller::Admin::DB - Catalyst Controller

=head1 METHODS

=over 4

=item 321

=back

=head1 LICENSE, AUTHOR, COPYRIGHT, SEE ALSO

L<Yesh::Manual> and L<Yesh>.

=cut
