package Yesh::Controller::Root;
use strict;
use warnings;
use parent "Catalyst::Controller";

__PACKAGE__->config->{namespace} = "";

sub auto :Private {
    my ( $self, $c ) = @_;
    unless ( $c->config->{configured}
             or $c->action =~ m,\A(setup|admin|man)/, )
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

sub default :Path { die "RC_404" }

sub render :ActionClass("RenderView") {}

sub end :Private {
    my ( $self, $c ) = @_;

    $c->forward("render") unless @{$c->error};
    # If there was an error in the render above, process it and re-render.
    if ( @{$c->error} )
    {
        $c->forward("Error") and $c->forward("render");
    }

    # If there is a new error at this point, it's time to redirect to
    # a static page or do something terribly simple...
}

1;

__END__
    #    $c->res->header( 'Cache-Control' => 'no-store, no-cache, must-revalidate,'.
    #                     'post-check=0, pre-check=0, max-age=0'
    #                     );
    #    $c->res->header( 'Pragma' => 'no-cache' );


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

