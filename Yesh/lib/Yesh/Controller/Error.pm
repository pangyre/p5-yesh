package Yesh::Controller::Error;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use HTTP::Status;
use YAML;

# To deal with known/expected/conditional exceptions; array because
# they must be run in order.
my @Exceptions = ( store_change => {
                                    match => qr/Store claimed to have a restorable user/,
                                   },
                   no_db => {
                             match => qr/DBI Connection failed: DBI connect\([^)]+\) failed: (.+)/,
#                             match => qr/Table '[^.]+.user' doesn't exist/, DB WENT AWAY...?
                            },
                   no_template => { match => qr/file error - ([^:]+): not found/,
                                    action => "no_template",
                                  },
                   generic => { match => qr/RC_(\d\d\d)(?::\s*(.+)\")?/,
                                },
                   unknown => { match => qr/\A/ },
                   );

sub process :Private {
    my ( $self, $c ) = @_;
    return 1 unless @{ $c->error };

    $c->stash( template => "error.tt" );

    # We only want the first thrown because it's all that matters.
    my $error = $c->error->[0];
    $c->log->error($error);

    my ( $status, $message );
  EXCEPTION:
    my @tmp_ex = @Exceptions;
    while ( my ( $action, $exception ) = splice(@tmp_ex,0,2) )
    {
        if ( @{$exception->{matches}} = $error =~ $exception->{match} )
        {
            $action = $exception->{action} if $exception->{action};
            $exception->{error} = $error;
            $c->clear_errors;
            $c->forward($action,[$exception]);
            return 1;
        }
    }
}

sub generic :Private {
    my ( $self, $c, $exception ) = @_;
    my ( $status, $message ) = @{$exception->{matches}};
#    $message ||= $status ? HTTP::Status::status_message($status) : "Unknown error";
    $status ||= 500;
    $c->stash( error => $message,
               title => HTTP::Status::status_message($status));
    $c->response->status( $status );
}

sub unknown :Private {
    my ( $self, $c, $error ) = @_;
    $error = YAML::Dump($error) if ref($error);
    $c->stash( error => "$error" || "Don't ask me, I just work here." );
    $c->response->status(500);
}

sub no_template :Private {
    my ( $self, $c, $exception ) = @_;
    $c->response->status(404);
    $c->stash( error => "The template was not found: @{$exception->{matches}}" );
}

sub no_db :Private {
    my ( $self, $c, $exception ) = @_;
    my ( $message ) = @{$exception->{matches}};
    $c->delete_session("DB is gone!");
    $c->stash( error => $message,
               template => "error/no_db.tt",
               title => HTTP::Status::status_message(503) );
}

sub store_change :Private {
    my ( $self, $c, $exception ) = @_;
    return if $c->stash->{_in_store_change}++; # Safety; only run once.
    $c->delete_session($exception->{error});
    # Try again now that the jammed session is cleared-
    $c->log->error("Re-dispatching to " . $c->action);
    $c->dispatch;
}

1;

__END__

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Yesh::Controller::Error in Error.');
}


=head1 AUTHOR

jinx

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
