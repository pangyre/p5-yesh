package Yesh::Controller::Admin;
use strict;
use warnings;
use parent 'Catalyst::Controller';

use List::MoreUtils qw( natatime );

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Matched Yesh::Controller::Admin in Admin.');
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
            uri => join("?", "http://search.cpan.org/perldoc", $module),
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
