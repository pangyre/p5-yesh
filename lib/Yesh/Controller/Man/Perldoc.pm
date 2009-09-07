package Yesh::Controller::Man::Perldoc;
use strict;
use warnings;
no warnings "uninitialized";
use parent 'Catalyst::Controller';

my $All_Good = eval <<'';
use Pod::POM;
use Pod::POM::View::HTML;
sub Pod::POM::View::HTML::view_seq_link_transform_path {
    my ( $self, $page ) = @_;
    return "?$page";
}
1;

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $All_Good )
    {
        $c->blurb("dependency/pod_pom");
        die "Pod::POM is not installed :( No perldocs for you: $@\n";
    }
    return 1;
}

sub index : Path Args(0) {
    my ( $self, $c ) = @_;
    my $name = $c->req->uri->query;
    ( my $path_part = $name ) =~ s,::,/,g;
    my $parser = Pod::POM->new({});

    my ( $pom );
    for my $try ( qw( .pm .pod .pl ), "" )
    {
        my $inc_key = $path_part . $try;
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

    unless ( $pom ) # Try the shell.
    {
        my $path = qx{ perldoc -l $name };
        $pom = $parser->parse_file($path) if $path;
    }

    $c->stash( pom => $pom,
               title => $name,
               name => $name,
               pod => Pod::POM::View::HTML->print($pom),
        );
}


1;

__END__

sub Pod::POM::View::HTML::view_seq_link_transform_path {
    my ( $self, $page ) = @_;
    return "?$page";
}
