package Yesh::Model::SelfTest;
use warnings;
use strict;
use parent "Catalyst::Model";

use App::Prove;
use File::Spec;

__PACKAGE__->config({
#    "lib" => Yesh->path_to("lib"),
#    test_dir => Yesh->path_to("t"),
#    timeout => 15,
#    verbose => 0
    });

sub run {
    my ( $self, $test, @args ) = @_;

    my $prove = App::Prove->new;
    $prove->verbose(1);
    for my $key (qw( lib )) {
        #next if $key eq 'test_dir';
        unshift @args, "--$key", $self->{$key};
    }

#    my @tests = ref $tests ? @$tests : $test;
#    push @args, File::Spec->catfile( $self->{test_dir}, $test );
#    my $prove = App::Prove->new;

#    die join" ", @args;

    push @args, "$test";
#  die join(" ", @args);
    eval { $prove->process_args(@args); 1; } or die join(" ", @args);
    $prove->run; # Handle failure somehow? This will return 1 or 0
}

1;


__END__

    my $p = App::Prove->new;
    $p->process_args(qw( --lib /Users/apv/depot/p5-yesh/lib /Users/apv/depot/p5-yesh/t/web/ok.t ));
    $p->run;
