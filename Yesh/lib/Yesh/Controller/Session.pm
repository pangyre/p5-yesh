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
    my $username = $c->req->param("username");
    my $password = $c->req->param("password") if $c->req->method eq "POST";

    #$c->log->debug( $user->check_password($password) ? "YES!!!!!" : "nope :(" );

    if ( $username and $password )
    {
        my $user = $c->model("DBIC::User")->find( username => $username );
        
        if ( $user and $user->check_password($password) )
        {
            $c->authenticate({ username => $username, password => $user->password }) or die;
        }
    }
}

1;
