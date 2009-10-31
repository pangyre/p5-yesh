package Yesh::Controller::Admin::Test;
use warnings;
use strict;
use parent 'Catalyst::Controller';

sub auto :Private {
    eval qq{
       use File::Which;
       use IPC::Run ();
       use Path::Class;
       use File::Find::Rule;
       1;
    };
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
               test_dir => Path::Class::Dir->new( $c->path_to("t")->stringify )
        );
}

sub run : Path {
    my ( $self, $c, @path ) = @_;
    die "Not a good idea...";
 #   my $test = $c->path_to("t/web",@path); # 321 verify no updir possible
    my $test = $c->path_to("t",@path); # 321 verify no updir possible
    my $prove = File::Which::which("prove");

    my @cmd = ( $prove, "-v", "-l", "lib", "$test" );
    my ( $in, $out, $err );

#    $| = 1;
#    IPC::Run::run \@cmd, \$in, \*STDOUT, \*STDERR, IPC::Run::timeout(30)
#        or die join("\n", $in, $out, $err, $?);

    IPC::Run::run \@cmd, \$in, \$out, \$err, IPC::Run::timeout(10);
    # or die join("\n", $in, $out, $err, $?);

    # $c->response->content_type("text/plain");
    # $c->response->body( join"\n", $out, $err);
    $c->stash( in  => $in,
               cmd => join(" ", @cmd),
               err => $err,
               out => $out );
}

1;

__END__


1; # Problems running/forking against itself.

__END__

=head1 NAME

Yesh::Controller::Admin::Test - Catalyst Controller

=head1 METHODS

=over 4

=item 321

=back

=head1 LICENSE, AUTHOR, COPYRIGHT, SEE ALSO

L<Yesh::Manual> and L<Yesh>.

=cut



    return 1;

    $c->model("SelfTest")->run( $c->path_to("t/web") );
    $c->model("SelfTest")->run( $c->path_to("t/web/ok.t") );

    $c->response->content_type("text/plain");
    $c->response->body( join"\n", @tests );                                                         

    return;
    # Messing with this doesn't seem to help...?
    local $SIG{CHLD} = "DEFAULT";
#    use App::Prove;
#    my $prove = App::Prove->new;
#    #    die join" ", @args;
#    eval {     $prove->process_args("-I" . $c->path_to("lib"), $tests[0] ) } or die join" ", "-I" . $c->path_to("lib"), $tests[0];
#    $prove->run; # Handle failure somehow? This will return 1 or 0
#    $c->response->content_type("text/plain");
#    $c->response->body( "OK!" );
#    return 1;
    my $prove = IPC::Cmd::can_run("prove");

    my ( $success, $error_code, $full_buf, $stdout_buf, $stderr_buf ) =
        IPC::Cmd::run( command => [ $prove, "-I" . $c->path_to("lib"), $tests[0] ],
                       timeout => 30,
                       verbose => 0 );


    $c->response->body( join"\n", @{$full_buf} );
#    $c->response->body( join"\n", @tests );

    my @tests = File::Find::Rule->file()
                     ->name( '*.t' )
                     ->in( $c->path_to("t/web") );

