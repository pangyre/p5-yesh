package Yesh::Test::C::Setup;
use parent "Yesh::Test";
use Test::More;
use Moose;
with qw( Yesh::MechCat );

#Yesh::Test::C::Setup->SKIP_CLASS("Only...");

sub prepare_setup_env : Test(startup) {
    my $self = shift;
    $ENV{YESH_CONFIG_LOCAL_SUFFIX} = "setup";
}

#sub per_test : Test(setup) {
#}

sub setup : Tests() {
    my $self = shift;
    $self->get_ok("/", "Request to / succeeds");
    
    is( $self->uri->path, "/setup",
          "/ redirects to /setup" );

    $self->text_contains('<yesh run="setup"/>',
                         "Correct config file was loaded")
        or $self->BAILOUT("Inappropriate configuration. It is dangerous to proceed.");

    $self->get_ok("/user", "Request to /user succeeds");
    is( $self->uri->path, "/setup",
        "/user redirects to /setup" );

    $self->get_ok("/man/perldoc");
    $self->content_contains("Documentation",
                            "Docs are visible before setup");
    $self->get("/setup/done");
    is( $self->status, 404,
        "/setup/done is 404" );
}

#sub moo : Test(teardown) {
#}

#sub goo : Test(shutdown) {
#}


1;

__END__

=pod

=head1 Run this test package

 perl -Ilib -It/lib -MYesh::Test::C::Setup -e "Yesh::Test::C::Setup->runtests"

=cut


package Test::Yesh::Controller::Setup;
use parent qw(Test::Yesh);
use Moose;
use Test::More;
use File::Temp qw( tempfile );
use FindBin;
use utf8;
use Symbol qw( delete_package );

# setenv TEST_VERBOSE 1 ; k ; perl -Ilib -It/lib -MTest::Yesh::Controller::Setup -le "Test::Yesh::Controller::Setup->runtests"

has "local_config" =>
    is => "ro",
    writer => "_local_config",
#    isa => "Path::Class::File",
    isa => "Str",
    ;


sub teardown : Test(teardown) {
    my $self = shift;
    unlink $self->local_config
        or die "Couldn't unlink ", $self->local_config, ": $!";
}

sub setup : Test(setup) {
    my $self = shift;
    undef $self->{mech};
    my $filename = [ tempfile("yesh_setup_XXXXXXXX",
                              DIR => "$FindBin::Bin/../conf",
                              UNLINK => 1,
                              SUFFIX => ".yml") ]->[1];

    ( $ENV{YESH_CONFIG_LOCAL_SUFFIX} ) = $filename =~ /yesh_setup_([^.]+)/;

    diag("Config file: " . $filename);
    $self->_local_config($filename);

#    for my $y ( grep /\A(Yesh\b.*)/, keys %INC )
    for my $path ( keys %INC )
    {
        next unless $path =~ /\AYesh/;
        my $module = $path;
        $module =~ s,/,::,g;
        $module =~ s,\.pm,,;
#        $module .= ".pm";
        diag($module);

#        delete_package($module);  # remove the Module::To::Reload namespace.
        delete $INC{$path} or die;       # delete the filename from the "loaded" list.
#        eval "use $module" or die $@;
    }
#    BAIL_OUT();
#    delete_package("Yesh");
#    delete $INC{"Yesh.pm"};
#    delete_package("Yesh");
#    delete $INC{"Catalyst/Runtime.pm"};
#    delete_package("Catalyst::Runtime");
    delete $INC{"Catalyst.pm"};
#    delete_package("Catalyst");

#    delete_package("Test::WWW::Mechanize::Catalyst::Test");
    delete $INC{"Test/WWW/Mechanize/Catalyst/Test.pm"};
    eval { require Test::WWW::Mechanize::Catalyst::Test };
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => "Yesh")
        or die "Couldn't create a Yesh Test::WWW::Mechanize::Catalyst object";
    $self->_mech( $mech );
    $self->mech->get("/setup");
}

sub _landing_issues : Tests {
    my $self = shift;
    my $mech = $self->mech;
    $mech->get_ok("/");
    like( $mech->uri, qr{/setup\z},
          "/ redirects to /setup" );
    my $one = $mech->content;
    $mech->get_ok("/user");
    like( $mech->uri, qr{/setup\z},
          "/user redirects to /setup" );
    my $two = $mech->content;
    is( $one, $two,
        "Setup landing content is the same from /user and /");
    $mech->get_ok("/man/perldoc");
    $mech->content_contains("Documentation",
                            "Docs are visible before setup");
    $mech->get("/setup/done");
    is( $mech->status, 404,
        "/setup/done is 404" );
}

sub auto_setup : Tests {
    my $self = shift;
    my $mech = $self->mech;
    $mech->click_ok("auto",
                    "Clicking simplistic set up");

    $mech->content_contains("Your database is set up",
                            "DB setup confirmed");

    $mech->content_contains("Create your account",
                            "Looks like admin account creation form is there");

    $mech->submit_form_ok({
                           fields => $self->config->{admin_data}
                          },
                          "Submitting registration form");

    $mech->content_contains("You’re done!",
                            "Success")
        or diag($mech->content);
}

sub sqlite_setup : Test(1) {
    my $self = shift;
    my $mech = $self->mech;

    # local $TODO = "Currently unimplemented";
    #use YAML; die YAML::Dump($self->config->{mysql_form});

    $mech->submit_form_ok({
                           fields => $self->config->{sqlite_form}
                          },
                          "Submitting normal-esque form with SQLite DSN");

    $mech->content_contains("Your database is set up",
                            "DB setup confirmed");

    $mech->content_contains("Create your account",
                            "Looks like admin account creation form is there");

    # use YAML;    die YAML::Dump($self->config->{admin_data});
    $mech->submit_form_ok({
                           fields => $self->config->{admin_data}
                          },
                          "Submitting registration form");

    $mech->content_contains("You’re done!",
                            "Success")
        or diag($mech->content);

}

sub mysql_setup : Test(9) {
    my $self = shift;
    local $TODO = "Currently unimplemented";
    eval { require DBD::mysql; 1; }
        or return "MySQL is not available";
    my $mech = $self->mech;

    #use YAML; die YAML::Dump($self->config->{mysql_form});

    $mech->submit_form_ok({
                           fields => $self->config->{mysql_form}
                          },
                          "Submitting normal-esque form with MySQL DSN");

    $mech->content_contains("Your database is set up",
                            "DB setup confirmed");

    $mech->content_contains("Create your account",
                            "Looks like admin account creation form is there");

    # use YAML;    die YAML::Dump($self->config->{admin_data});
    $mech->submit_form_ok({
                           fields => $self->config->{admin_data}
                          },
                          "Submitting registration form");

    $mech->content_contains("You’re done!",
                            "Success")
        or diag($mech->content);
}

sub postgres_setup : Test(1) {
    my $self = shift;
    local $TODO = "Currently unimplemented";
    eval { require DBD::Pg; 1; }
        or return "PostgreSQL is not available";
    my $mech = $self->mech;
    ok(0);
}

1;

__END__


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
    my $db_name = "dummy.sqlite";
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
    my $config_file = $c->path_to("conf/yesh_local.yml");
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


sub startup : Test(startup) {
    my $self = shift;
    my $filename = [ tempfile("yesh_setup_XXXXXXXX",
                              DIR => "$FindBin::Bin/../conf",
                              SUFFIX => ".yml") ]->[1];

    ( $ENV{YESH_CONFIG_LOCAL_SUFFIX} ) = $filename =~ /yesh_setup_([^.]+)/;

    diag($filename);
    $self->SUPER::startup;
    # my $local_config = $self->c->path_to($filename);
    $self->_local_config($filename);
}

321
#    $self->builder->skip("OH HAI");
    use Test::More;
    local $TODO = "live currently unimplemented";
    Test::More::ok(0);

#  TODO: { "Currently unimplemented" };

