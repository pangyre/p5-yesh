package Yesh::Controller::User;
use Moose;
use namespace::autoclean;
BEGIN { extends "Catalyst::Controller::HTML::FormFu" }


use Digest::MD5;
use MIME::Lite;
use Data::UUID;

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( users => $c->model("DBIC::User")->search_rs() );
}

sub load :Chained("/") PathPart("user/id") CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $id ||= $c->request->arguments->[0]; # for forwards
    $c->stash->{user} ||= $c->model("DBIC::User")->find($id)
        or die "RC_404: No such user";

# forward to search with it?
}

sub view :PathPart("") Chained("load") Args(0) {
    my ( $self, $c ) = @_;
}

sub reset_edit : PathPart("edit") Chained("load") Args(1) {
    my ( $self, $c, $token ) = @_;
    my $check = $c->model("CHI")->get("reset" . $c->stash->{user}->id);    
    $check or die "RC_404";
    $check eq $token or die "RC_403";
    $c->stash(token_ok => 1);
    $c->go("/user/edit");
}

sub edit : Chained("load") Args(0) FormConfig {
    my ( $self, $c ) = @_;
    $c->require_ssl if $self->{secure_edit};
    my $form = $c->stash->{form};
    my $user = $c->stash->{user};
    die "RC_403" unless $c->user_exists
        and $user->id eq $c->user->id
        or $c->stash->{token_ok}
        or $c->check_user_roles("admin");

    if ( $form->submitted_and_valid )
    {
        for my $valid ( $form->valid )
        {
            next unless $user->can($valid);
            # Never "blank out" a password.
            next if $valid eq "password" and not $form->param_value($valid);
            $user->$valid( $form->param_value($valid) );
        }

        if ( $user->is_changed )
        {
            $user->update;
            $c->response->redirect( $c->uri_for_action("user/view", [ $user->id ]) );
            $c->model("CHI")->remove("reset" . $c->stash->{user}->id)
                if $c->stash->{token_ok};
            $c->detach;
        }
        else
        {
            # 321 blurb
            $c->blurb("user/no_change");
            # die "You didn't change anything...";
        }
    }
    $form->model->default_values( $user )
        unless $form->submitted;
}

sub register : Local Args(0) Form {
    my ( $self, $c ) = @_;
    $c->require_ssl if $self->{secure_registration};
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
            if ( $self->{new_users_get_author_role} )
            {
                my $author_role = $c->model("DBIC::SiteRole")
                    ->search({ name => "author" })->single
                    || confess("Author role is not configured");
                $user->add_to_site_roles($author_role);
            }

            $c->authenticate({ username => $user->username,
                               password => $form->param_value("password") })
                or die "Could not auto-sign-in";
            $c->response->redirect($c->uri_for("/"));
        }
    }
    else
    {
        # die "why are you here...?"
    }
}

# This is mildly more hackable than directly working on passwords
# because it lacks the Eks cost. Needs to have a cache key or
# something instead. It'll be self-expiring too so that's even better.

sub reset : Local Args(0) FormConfig {
    my ( $self, $c ) = @_;
    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid )
    {
        $c->blurb("user/reset");
        $c->flash_blurb(1);
        $c->response->redirect($c->uri_for("/"), 302);

        # Letting the user know if this worked or not is a security
        # risk b/c it allows probing of accounts. So any successful
        # submit is reported to the user the same way.

        return unless my $user = $c->model('DBIC::User')
            ->search({ email => $form->param_value("email")})
            ->single;

        # Prevent abuse and confusion by only doing one at a time.
        $c->detach() if $c->model("CHI")->get("reset" . $user->id);

        my $token = lc Data::UUID->new->create_str;
        $c->model("CHI")->set("reset" . $user->id, $token,
                              $self->{reset_token_lives_for} || "15 minutes");

        # This, or some variety, really should work...
        #my $reset_uri = $c->uri_for_action("user/reset_edit", $token, [ $user->id ]);
        my $reset_uri = $c->uri_for("/user/id", $user->id, "edit", $token );
        my $output = $c->view("Alloy")
            ->render($c, "user/reset_email.tt",
                     { reset_uri => $reset_uri });

        my $host = $c->request->uri->host;
        my $msg = MIME::Lite->new
            (
             From    => "do-not-reply\@$host",
             To      => $user->email,
             Subject => "OH HAI",
             Data    => "Message for you: $reset_uri",
            );
        $msg->attr("content-type"         => "text/plain");
        $msg->attr("content-type.charset" => "utf-8");

        if ( $host =~ /\blocal/ )
        {
            die $msg->as_string;
        }
        else
        {
            $msg->send or $c->log->error("Couldn't send mail!");
        }
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

=head1 Name

Yesh::Controller::User - Catalyst Controller.

=head1 Description

Catalyst Controller.

=head1 Methods

=head2 index

=cut
