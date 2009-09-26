package Yesh::Controller::Admin::DB;
use strict;
use warnings;
use parent "Catalyst::Controller";
use DBIx::Class::ResultSet::HashRef;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body("Matched Yesh::Controller::Admin::DB->index.");
}

sub schema : Local Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( schema => $c->model("DBIC")->schema );
}

sub dump : Local Args(0) {
    my ( $self, $c ) = @_;
    my $schema = $c->model("DBIC")->schema;
    for my $source ( $schema->sources )
    {
        my $rs = $schema->resultset($source);
        $rs->result_class("DBIx::Class::ResultClass::HashRefInflator");
        push @{$c->stash->{rows}}, $rs->all();
    }
}

sub load : Local Args(0) {
    my ( $self, $c ) = @_;

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
