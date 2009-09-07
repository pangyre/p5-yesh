package Yesh::Controller::Man::Perldoc;
use strict;
use warnings;
use parent 'Catalyst::Controller';

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( eval { require Pod::POM; require Pod::POM::View::HTML } )
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

    my ( $pom );
    for my $try ( qw( .pm .pod .pl ), "" )
    {
        my $inc_key = $item . $try;
        if ( -r $INC{$inc_key} )
        {
            $pom = $parser->parse_file( $INC{$inc_key} );
            last;
        }
        else
        {
            for my $path ( @INC )
            {
                if ( -r "$path/$inc_key" )
                {
                    $pom = $parser->parse_file( "$path/$inc_key" );
                    last;
                }
            }
        }
    }
    $c->stash( pom => $pom,
               pod => Pod::POM::View::HTML->print($pom),
        );
}

1;

__END__
