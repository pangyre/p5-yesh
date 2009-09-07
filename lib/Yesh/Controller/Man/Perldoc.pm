package Yesh::Controller::Man::Perldoc;
use strict;
use warnings;
use parent 'Catalyst::Controller';

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( eval { require Pod::POM } )
    {
        $c->blurb("dependency/pod_pom");
        die "Pod::POM is not installed :( No perldocs for you: $@\n";
    }
    return 1;
}

sub index : Path Args(0) {
    my ( $self, $c ) = @_;
    my $item = $c->req->uri->query;
    $item =~ s,::,/,g;
    my $parser = Pod::POM->new({});

    for my $try ( qw( .pm .pod .pl ), "" )
    {
        my $inc_key = $item . $try;
        next unless -r $INC{$inc_key};
        $c->stash( pom => $parser->parse_file( $INC{$inc_key} ) );
    }
}

1;

__END__
