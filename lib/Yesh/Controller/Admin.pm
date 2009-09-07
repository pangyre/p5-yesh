package Yesh::Controller::Admin;
use strict;
use warnings;
use parent 'Catalyst::Controller';

use List::MoreUtils qw( natatime );
use Scalar::Util qw( blessed );

sub auto : Private {
    my ( $self, $c ) = @_;
    return $c->check_any_user_role(qw( admin owner )) if $c->config->{configured};
    return 1;
}

sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
}

sub config : Local {
}

sub env : Local {
    my ( $self, $c ) = @_;
    $c->stash( env => $c->engine->env,
               engine => blessed($c->engine),
        );
}

sub inc : Local {
    my ( $self, $c ) = @_;
    my @module = grep { /^\w/ }
        map { s/\.\w+\z// and s,/,::,g; $_ } keys %INC;
    %{ $c->stash->{versions} } = map { $_ => $_->VERSION } sort @module;
    $c->stash( inc => { %INC } );
}

sub dependencies : Local {
    my ( $self, $c ) = @_;
    my $makefile = $c->path_to("Makefile.PL")->slurp;
    my @deps = $makefile =~ /\nrequires\s+['"](\S+?)['"][^\w;]*(?:([\d.]+)|;)/g;
    my $it = natatime 2, @deps;
    while ( my ( $module, $version ) = $it->() )
    {
        my $usage = "use $module";
        $usage .= " $version" if $version;
        eval $usage;
        my $info = {
            module => $module,
            version => $version || $module->VERSION,
            result => $@ || "OK",
        };
        unless ( $@ )
        {
            ( my $plain_name = $module ) =~ s,::,/,g;
            $plain_name .= ".pm";
            $info->{inc} = $INC{$plain_name};
        }
        else
        {
            push @{$c->stash->{broken}}, $module;
        }
        push @{$c->stash->{dependencies}}, $info;
        $c->log->debug("$usage --> " . ( $@ || "fine!" ));
    }

}



1;

__END__

=head1 NAME

Yesh::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut
