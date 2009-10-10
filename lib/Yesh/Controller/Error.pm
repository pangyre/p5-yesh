package Yesh::Controller::Error;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use HTTP::Status;
use YAML;

# To deal with known/expected/conditional exceptions; array because
# they must be run in order.
my @Exceptions = (
    store_change => {
        rx => qr/Store claimed to have a restorable user/,
    },
    no_db => {
        rx => [
            qr/(DBI Exception.+) at .+/,
            qr/(no such table\S*\s+\S+)/,
            ],
        #rx => qr/DBI connect\([^)]+\) failed: (.+)|DBI Exception:?\s+(.+)/,
    },
    no_template => {
        rx => qr/file error - ([^:]+): not found/,
        action => "no_template",
    },
    generic => {
        rx => qr/\bRC_(\d\d\d)(?::?\s*(.+)?")\z/s,
    },
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
        my @rxes = ref($exception->{rx}) eq "ARRAY" ?
            @{$exception->{rx}} : $exception->{rx};
      RX:
        for my $rx ( @rxes )
        {
            if ( @{$exception->{matches}} = $error =~ $rx )
            {
                $action = $exception->{action} if $exception->{action};
                $exception->{error} = $error;
                $c->clear_errors;
                $c->forward($action,[$exception]);
                return 1;
            }
        }
    }
    $c->clear_errors;
    $c->forward("generic",
                [
                 { matches => [ 500,
                                ref($error) ? YAML::Dump($error) : $error ]
                 }
                ]);
}

sub generic :Private {
    my ( $self, $c, $exception ) = @_;
    my ( $status, $message ) = @{$exception->{matches}};
    $status ||= 500;
    $c->stash( error => $message || "[No error message captured.]",
               status => $status,
               title => join(" \x{b7} ", $status, HTTP::Status::status_message($status) ),
        );
    $c->response->status( $status );
}

sub no_template :Private {
    my ( $self, $c, $exception ) = @_;
    $c->response->status(404);
    $c->stash( error => "The template was not found: @{$exception->{matches}}" );
}

sub no_db :Private {
    my ( $self, $c, $exception ) = @_;
    my ( @message ) = @{$exception->{matches}};
    $c->delete_session("DB is gone!");
    $c->stash( error => join(", ", @message),
               template => "error/no_db.tt",
               status => 503,
               title => join(" \x{b7} ", 503, HTTP::Status::status_message(503) ),
        );
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
