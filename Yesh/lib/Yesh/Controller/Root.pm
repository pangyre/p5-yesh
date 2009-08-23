package Yesh::Controller::Root;
use strict;
use warnings;
use parent "Catalyst::Controller";

__PACKAGE__->config->{namespace} = "";

sub auto :Private {
    my ( $self, $c ) = @_;
    unless ( $c->config->{configured}
             or $c->action =~ m,\Asetup/, )
    {
        $c->response->redirect($c->uri_for_action("setup/index"));
        return 0;
    }
    return 1;
}

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
    $c->go("Article", "index");
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body("Not found");
    $c->response->status(404);
}

sub end : ActionClass("RenderView") {}

1;

__END__

=head1 NAME

Yesh::Controller::Root - Root Controller for L<Yesh>.

=head1 METHODS

=head2 index

=head2 default

Our 404 catcher for all unhandled requests.

=head2 end

Attempt to render a view, if needed.

=head1 COPYRIGHT AND LICENSE

See L<Yesh>.

=cut

