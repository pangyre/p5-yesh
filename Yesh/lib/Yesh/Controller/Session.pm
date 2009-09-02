package Yesh::Controller::Session;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use URI;

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
#    $c->go("login");
#}

sub login :Global {
    my ( $self, $c, @args ) = @_;

    my $return_to = $c->flash->{return_to};

    $return_to ||= $c->request->referer
        if $c->request->referer
        and URI->new($c->request->referer)->host eq $c->request->uri->host
        and $c->request->referer ne $c->request->uri->as_string;

    $return_to ||= $c->uri_for("/")->as_string;
    $c->flash( return_to => $return_to );
    $c->keep_flash("return_to");

    my $username = $c->req->param("username");
    my $password = $c->req->param("password") if $c->req->method eq "POST";

    #$c->log->debug( $user->check_password($password) ? "YES!!!!!" : "nope :(" );

    if ( $username and $password )
    {
        my $user = $c->model("DBIC::User")->search( username => $username )->single;
        
        if ( $user and $user->check_password($password) )
        {
            $c->authenticate({ username => $username, password => $user->password }) or die;
            $c->clear_flash;
            $c->response->redirect( $return_to );
            $c->detach;
        }
    }
    $c->log->debug("return to: $return_to");
}

sub logout :Global Args(0) {
    my ( $self, $c ) = @_;
    $c->delete_session("User manually signed-out");
    $c->logout();
    $c->response->redirect( $c->uri_for("/") );
    #$c->blurb("logout/success");
}

1;
