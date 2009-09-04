package Yesh::Controller::User;
use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( users => $c->model("DBIC::User")->search_rs() );
}

sub load :Chained("/") PathPart("user/id") CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $id ||= $c->request->arguments->[0]; # for forwards
    $c->stash->{user} = $c->model("DBIC::User")->find($id)
        or die "RC_404: No such user";
# forward to search with it?
}

sub view :PathPart("") Chained("load") Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( title => $c->stash->{user}->username );
}

sub register : Local Args(0) Form {
    my ( $self, $c ) = @_;
    my $form = $self->form();
    $form->load_config_filestem("user/register");
    $form->process;
    $c->stash( form => $form );
    if ( $form->submitted_and_valid )
    {
        my $user = $c->model('DBIC::User')->new_result({});
        eval { $form->model->update($user) };
        # Just guessing on the first(MySQL) report.
        if ( $@ =~ /duplicate entry .+? for key (\w+)|column (\w+) is not unique/i )
        {
            my ( $key, $col ) = ( $1, $2 );
            $col ||= [ $user->columns ]->[$key-1] if $key;
            $col || die "Could not determine which column failed constraint";
            $form->get_field($col)
                ->get_constraint({ type => 'Callback' })
                ->force_errors(1);
            $form->process();
            return;
        }
        elsif ( $@ )
        {
            die $@;
        }
        else
        {
            $c->authenticate({ username => $user->username,
                               password => $user->password }) or die "Could not auto-sign-in";
            $c->response->redirect($c->uri_for("/"));
        }
    }
    else
    {
        # die "why are you here...?"
    }
}

1;

__END__

package Yesh::Controller::User;
use strict;
use warnings;
no warnings "uninitialized";
use parent qw(
                 Catalyst::Controller::HTML::FormFu
                 Catalyst::Controller::REST
            );
use Email::Valid;

__PACKAGE__->config(
    'stash_key' => "rest",
    'map'       => {
        'text/html'  => [ 'View', 'Alloy' ],
        'text/xhtml' => [ 'View', 'Alloy' ],
        'text/xml'         => 'XML::Simple',
        'text/x-yaml'      => 'YAML',
        'application/json' => 'JSON',
    },
    default => 'text/html',
    );

sub index : Path Args(0) ActionClass('REST') FormConfig {}

sub index_GET {
    my ( $self, $c ) = @_;
    $self->status_ok($c,
                     entity => {
                         users => $c->model("DBIC::User")->search_rs,
                     }
        );
}

sub index_POST {
    my ( $self, $c ) = @_;
    $c->go("register");
}

sub register : Local Args(0) Form {
    my ( $self, $c ) = @_;
    my $form = $self->form();
    $form->load_config_filestem("user/register");
    $form->process;
    $c->stash( form => $form );
    if ( $form->submitted_and_valid )
    {
        my $user = $c->model('DBIC::User')->new_result({});
        eval { $form->model->update($user) };
        # Just guessing on the first(MySQL) report.
        if ( $@ =~ /duplicate entry .+? for key (\w+)|column (\w+) is not unique/i )
        {
            my ( $key, $col ) = ( $1, $2 );
            $col ||= [ $user->columns ]->[$key-1] if $key;
            $col || die "Could not determine which column failed constraint";
            $form->get_field($col)
                ->get_constraint({ type => 'Callback' })
                ->force_errors(1);
            $form->process();
            return;
        }
        elsif ( $@ )
        {
            die $@;
        }
        else
        {
            $c->authenticate({ username => $user->username,
                               password => $user->password }) or die "Could not auto-sign-in";
            $c->response->redirect($c->uri_for("/"));
        }
    }
    else
    {

    }
}

1;

__END__

=head1 NAME

Yesh::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 index

=cut
