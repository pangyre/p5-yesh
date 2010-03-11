package Yesh::Controller::Admin;
use Moose;
use namespace::autoclean;
BEGIN { extends "Catalyst::Controller" }

use List::MoreUtils qw( natatime );

sub auto : Private {
    my ( $self, $c ) = @_;
    if ( $c->config->{configured} )
    {
        $c->check_any_user_role(qw( admin owner ))
            or die "RC_403";
    }
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

sub proc : Local {
    my ( $self, $c ) = @_;
    eval "use Proc::ProcessTable; 1"
        or die "RC_503: Proc::ProcessTable is not available: $@";
    $c->stash(process_table => Proc::ProcessTable->new( enable_ttys => 0 ) );
}

sub at : Local {
    eval "use Schedule::At; 1"
        or die "RC_503: Schedule::At is not available: $@";

}

1;

__END__

=head1 NAME

Yesh::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub ab :Local {
    die "+" . join(" ", $^X, $0, @ARGV);
}

sub restart_yesh : Local {
    my ( $self, $c ) = @_;
    if ( $c->engine eq "Catalyst::Engine::HTTP" )
    {
        my $config = $c->path_to("conf/yesh_local.yml");
        system("touch", $config);
        die;
    }
}

