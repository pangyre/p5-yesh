package Yesh::Controller::Session;
use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';
use URI;

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
#    $c->go("login");
#}

sub login :Global FormConfig {
    my ( $self, $c, @args ) = @_;

    my $return_to = $c->flash->{return_to};

    $return_to ||= $c->request->referer
        if $c->request->referer
        and URI->new($c->request->referer)->host eq $c->request->uri->host
        and $c->request->referer ne $c->request->uri->as_string;

    $return_to ||= $c->uri_for("/")->as_string;
    $c->flash( return_to => $return_to );
    $c->keep_flash("return_to");

    $c->require_ssl if $self->{secure_login};

    my $form = $c->stash->{form};
    $c->log->debug("return to: $return_to");
    if ( $form->submitted_and_valid )
    {
        my $username = $form->param_value("username");
        my $password = $form->param_value("password");

        if ( $c->authenticate({ username => $username, password => $password }) )
        {
            $c->clear_flash;
            $c->response->redirect( $return_to );
            $c->detach;
        }
        else
        {
            $form->get_field("password")
                ->get_constraint({ type => 'Callback' })
                ->force_errors(1);
            $form->get_field("username")
                ->get_constraint({ type => 'Callback' })
                ->force_errors(1);
            $form->process();
            return;
        }
    }
}

sub logout :Global Args(0) {
    my ( $self, $c ) = @_;
    $c->delete_session("User manually signed-out");
    $c->logout();

    my $return_to = $c->request->referer
        if $c->request->referer
        and URI->new($c->request->referer)->host eq $c->request->uri->host
        and $c->request->referer ne $c->request->uri->as_string;

    $return_to ||= $c->uri_for("/")->as_string;
    $c->response->redirect( $return_to );
    $c->blurb("logout/success");
}


1;

__END__

=pod

=head1 Name

Yesh::Controller::Session - Session related actions for L<Yesh>.

=head1 Methods

=head2 login

=head2 logout

Attempt to render a view, if needed.

=cut


sub password_reset : Global {
    my ( $self, $c, $token, @more ) = @_;
    die "RC_404" if @more;
  # $self->{reset_token_lives_for}
    if ( $c->request->method eq "POST" )
    {
        # REQUESTING ONE, TOKEN IS SENT ONLY, GOOD FOR...
    }
    elsif ( $token and $c->request->method eq "GET" )
    {
        
        # USING ONE
    }
    else
    {
        die "RC_405";
    }
}

