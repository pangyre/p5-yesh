package Yesh::Controller::Setup;
use strict;
use warnings;
use parent "Catalyst::Controller::HTML::FormFu";
use YAML qw( LoadFile DumpFile );
use Data::UUID;
use Carp;

# There should be a page block to make sure the user/admin has read
# and understood that setting up after the config is already there is
# dangerous.

# MUST NOT BE ACCESSIBLE IF IT'S DONE ALREADY?
sub auto : Private {
    my ( $self, $c ) = @_;

    if ( $c->config->{configured}
         and
         $c->user_exists
         and
         $c->check_user_roles("admin")
        )
    {
        #$c->stash( blurb ...
        $c->stash( warning => 1 );
    }
    elsif ( $c->config->{configured}
            and
            eval { $c->model("DBIC::User")->search->count == 0 } )
    {
        my $config = $c->path_to("conf/yesh_local.yml");
        $config->remove or
            die "Your site has a serious problem. Try deleting $config and then visiting /setup again";
    }
    elsif ( $c->config->{configured} )
    {
        die "RC_403: Site is configured already.\n";
    }
    return 1;
}

sub index : Path Args(0) FormConfig {
    my ( $self, $c ) = @_;
    my $can_auto = -w $c->path_to("/") ? 1 : 0;
    $c->stash( template => "setup/index.tt",
               user => scalar getpwuid($> || $<),
               can_auto => $can_auto,
             );
    if ( $c->request->param("auto") )
    {
        $c->delete_session("Deploying DB");
        $c->config->{configured} = undef;
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
    my $name = lc Data::UUID->new->create_str;
    my $db_name = "etc/$name";
    my $db = $c->path_to($db_name);
    $db->remove and $c->log->info("Removed sqlite db: $db");

    my $dsn_config = "dbi:SQLite:__path_to($db_name)__";
    my $dsn_real = "dbi:SQLite:$db";
    my $schema = $c->model("DBIC")
        ->schema
        ->connect($dsn_real);

    $c->model("DBIC")->schema($schema);

    eval { $schema->deploy() };
    die "Caught error in schema deployment: $@" if $@;
    # Update config file here.
    my $model_config = $c->config->{"Model::DBIC"};
    $model_config->{connect_info}->[0] = $dsn_config;
    $model_config->{connect_info}->[3]->{unicode} = 1;
    $self->_load_baseline($c, $schema);
    $self->_write_local_yaml($c, { "Model::DBIC" => $model_config });
    $c->response->redirect($c->uri_for_action("setup/admin"));
}

sub _write_local_yaml : Private {
    my ( $self, $c, $data ) = @_;
    my $suffix = $ENV{YESH_CONFIG_LOCAL_SUFFIX} || "local";
    my $config_file = $c->path_to("conf/yesh_$suffix.yml");
    my $config = LoadFile("$config_file") if -f $config_file;
#    require Hash::Merge;
#    $config = Hash::Merge::merge($config, $data);
    # Overwrite merge is what we really want.
    $config = { %{$config||{}}, %{$data} };

    $c->log->info("Creating $config_file");
    DumpFile($config_file, $config)
        or die "Couldn't update $config_file";
}

sub admin : Local Args(0) {
    my ( $self, $c ) = @_;
    # As a transaction if possible! 321
    $c->forward("/user/register");
    if ( $c->stash->{form}->submitted_and_valid )
    {
        # Give the new user admin roles.
        my $admin = $c->user or die "No user is in the context";
        my $admin_role = $c->model("DBIC::SiteRole")->search({ name => "admin" })->single
            || croak "Admin role is not configured";
        $admin->add_to_site_roles($admin_role);

        unless ( $admin->has_site_role("author") ) # Register might have done this already.
        {
            my $author_role = $c->model("DBIC::SiteRole")->search({ name => "author" })->single
                || croak "Author role is not configured";
            $admin->add_to_site_roles($author_role)
        }

        $self->_write_local_yaml($c,
                                 { configured => join(" ",
                                                      $admin->created->ymd,
                                                      $admin->created->hms,
                                       )
                                 });
        $c->config->{configured} = "*** LIVE *** (restart to pick-up configured date/time stamp)";
        $c->response->redirect($c->uri_for_action("setup/done"));
    }
}

sub done : Local Args(0) {
    my ( $self, $c ) = @_;
    die "RC_404"
        unless $c->config->{configured};
    # 321 this should be a blurb to the homepage instead?
}

sub _load_baseline {
    my ( $self, $c ) = @_;
    my $baseline_file = $c->path_to("etc/baseline.yml");
    my $baseline = LoadFile("$baseline_file")
        or croak "Baseline data file '$baseline_file' is missing or broken";
    for my $result_class ( keys %{$baseline} )
    {
        my $rs = $c->model("DBIC::$result_class");
        for my $row ( @{ $baseline->{$result_class} } )
        {
            $rs->create($row)->update;
        }
    }
    1;
}

# sub end :ActionClass("RenderView") {}

1;

__END__

Robert'); DROP TABLE Users; --

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


    if ( 
         and not $c->check_user_roles("admin") )
    {
        die "Already configured, cowboy";
    }
    
