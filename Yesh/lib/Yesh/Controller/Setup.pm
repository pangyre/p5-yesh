package Yesh::Controller::Setup;
use strict;
use warnings;
use parent "Catalyst::Controller::HTML::FormFu";
use YAML qw( LoadFile DumpFile );

sub index : Path Args(0) FormConfig {
    my ( $self, $c ) = @_;
    my $can_auto = -w $c->path_to("/") ? 1 : 0;
    $c->stash( template => "setup/index.tt",
               user => scalar getpwuid($> || $<),
               can_auto => $can_auto,
             );

}

sub deploy_db : Private {
    my ( $self, $c ) = @_;
}

sub create_administrator : Private {
    my ( $self, $c ) = @_;
}

sub _deploy_sqlite : method {
    my ( $self, $c ) = @_;

    
}

1;

__END__





    $c->response->body(<<"");
No admin user? Create one.
<br />
Lost admin user? Must provide token or email or something to prevent nuissance.

my $dns = join(":",
               "dbi",
               $c->request->body_params->{dbd},
               $c->request->body_params->{db_name},
               $c->request->body_params->{db_name},
| db_name                             | yesh                                 |
| dbd                                 | Pg                                   |
| host                                | localhost                            |
| password                            | 1234asdf                             |
| user                                | me                                   |

               dbi:DriverName:database_name
               dbi:DriverName:database_name@hostname:port
               dbi:DriverName:database=database_name;host=hostname;port=port

There is no standard for the text following the driver name. Each driver is free to use whatever syntax it wants. The only requirement the DBI makes is that all the information is supplied in a single string. You must consult the documentation for the drivers you are using for a description of the syntax they require.

