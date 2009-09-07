package Yesh::Controller::Man::Perldoc;
use strict;
use warnings;
no warnings "uninitialized";
use parent 'Catalyst::Controller';
use Encode;

my $All_Good = eval <<'';
    require Pod::POM;
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
            last if "$pom";
        }
        else
        {
            for my $path ( @INC )
            {
                if ( -r "$path/$inc_key" )
                {
                    $pom = $parser->parse_file( "$path/$inc_key" );
                    last if "$pom";
                }
            }
        }
    }

    unless ( "$pom" ) # Try the shell.
    {
        my $path = qx{ perldoc -l $name };
        $pom = $parser->parse_file($path) if $path;
    }

    my $title = "$pom" ? $name : "Pod Viewer";
    $c->stash( pom => "$pom" ? $pom : "",
               title => $title,
               name => $name,
               pod => Encode::decode_utf8(Yesh::Pod::POM::View::HTML->print($pom)),
        );
}

BEGIN {
    package Yesh::Pod::POM::View::HTML;
    use parent "Pod::POM::View::HTML";

    sub view_seq_link_transform_path {
        my ( $self, $page ) = @_;
        return "?$page";
    }

sub view_seq_link {
    my ($self, $link) = @_;

    # view_seq_text has already taken care of L<http://example.com/>
    if ($link =~ /^<a href=/ ) {
        return $link;
    }

    # full-blown URL's are emitted as-is
    if ($link =~ m{^\w+://}s ) {
        return make_href($link);
    }

    $link =~ s/\n/ /g;   # undo line-wrapped tags

    my $orig_link = $link;
    my $linktext;
    # strip the sub-title and the following '|' char
    if ( $link =~ s/^ ([^|]+) \| //x ) {
        $linktext = $1;
    }

    # make sure sections start with a /
    $link =~ s|^"|/"|;

    my $page;
    my $section;
    if ($link =~ m|^ (.*?) / "? (.*?) "? $|x) { # [name]/"section"
        ($page, $section) = ($1, $2);
    }
    elsif ($link =~ /\s/) {  # this must be a section with missing quotes
        ($page, $section) = ('', $link);
    }
    else {
        ($page, $section) = ($link, '');
    }

    # warning; show some text.
    $linktext = $orig_link unless defined $linktext;

    my $url = '';
    if (defined $page && length $page) {
        $url = $self->view_seq_link_transform_path($page);
    }

    # append the #section if exists
    $url .= "#$section" if defined $url and
        defined $section and length $section;

     $linktext =~ s,\A/,, if defined $url and
         defined $section and length $section;

    return Pod::POM::View::HTML::make_href($url, $linktext);
}

    sub view_head1 {
        my ($self, $head1) = @_;
        my $title = $head1->title->present($self);
        return "<h2>$title</h2>\n\n"
            . $head1->content->present($self);
    }

    sub view_head2 {
        my ($self, $head2) = @_;
        my $title = $head2->title->present($self);
        return "<h3>$title</h3>\n"
            . $head2->content->present($self);
    }

    sub view_head3 {
        my ($self, $head3) = @_;
        my $title = $head3->title->present($self);
        return "<h4>$title</h4>\n"
            . $head3->content->present($self);
    }

    sub view_head4 {
        my ($self, $head4) = @_;
        my $title = $head4->title->present($self);
        return "<h5>$title</h5>\n"
            . $head4->content->present($self);
    }

    sub view_pod {
        my ($self, $pod) = @_;
        return join("\n",
                    '<div class="pod">',
                    $pod->content->present($self),
                    '</div>');
    }
}

1;

__END__

sub Pod::POM::View::HTML::view_seq_link_transform_path {
    my ( $self, $page ) = @_;
    return "?$page";
}
