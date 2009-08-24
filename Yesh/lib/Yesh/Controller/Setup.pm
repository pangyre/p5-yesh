package Yesh::Controller::Setup;
use strict;
use warnings;
use parent "Catalyst::Controller::HTML::FormFu";
use YAML qw( LoadFile DumpFile );

# MUST NOT BE ACCESSIBLE IF IT'S DONE ALREADY?
# sub auto : Private {

sub index : Path Args(0) FormConfig {
    my ( $self, $c ) = @_;
    my $can_auto = -w $c->path_to("/") ? 1 : 0;
    $c->stash( template => "setup/index.tt",
               user => scalar getpwuid($> || $<),
               can_auto => $can_auto,
             );
    if ( $c->request->param("auto") )
    {
        $c->detach("_deploy_sqlite");
    }
}

sub deploy_db : Private {
    my ( $self, $c ) = @_;
}

sub create_administrator : Private {
    my ( $self, $c ) = @_;
}

sub _deploy_sqlite : Private {
    my ( $self, $c ) = @_;
    # Ensure uniqueness?
    my $db_name = "dummy.sqlite";
    my $db = $c->path_to($db_name);
    my $dsn_config = "dbi:SQLite:__path_to($db_name)__";
    my $dsn_real = "dbi:SQLite:$db";
    $db->remove;
    my $schema = $c->model("DBIC")
        ->schema
        ->connect($dsn_real);

    eval { $schema->deploy(); };
    die $@ if $@;
    # Update config file here.
    #my $model_config = $c->model("DBIC")->config;
    my $model_config = $c->config->{"Model::DBIC"};
    $model_config->{connect_info}->[0] = $dsn_config;
    $self->_write_local_yaml($c, { "Model::DBIC" => $model_config });
    $c->response->redirect($c->uri_for_action("setup/admin"));
}

sub _write_local_yaml : Private {
    my ( $self, $c, $data ) = @_;
    my $config_file = $c->path_to("yesh_local.yml");
    $c->log->info("Creating $config_file");
#    my $config = LoadFile("$config_file") if -f $config_file;
#    $config ||= {};
#    require Hash::Merge;
#    $config = Hash::Merge::merge( $config, $data );
    DumpFile($config_file, $data)
        or die "Couldn't update $config_file";
}

sub admin : Local Args(0) {
    my ( $self, $c ) = @_;
    $c->forward("/user/register");
    if ( $c->stash->{form}->submitted_and_valid )
    {
        # Give the new user admin roles.
        $c->response->redirect($c->uri_for_action("setup/done"));
    }
}

sub done : Local Args(0) {
    my ( $self, $c ) = @_;
}


1;

__END__


    $c->response->body(<<"");
No admin user? Create one.
<br />
Lost admin user? Must provide token or email or something to prevent nuissance.

my $dsn = join(":",
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

