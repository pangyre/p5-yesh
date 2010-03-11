package Yesh::Controller::Admin::DB;
use Moose;
use namespace::autoclean;
BEGIN { extends "Catalyst::Controller" }

use JSON::XS;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body("Matched Yesh::Controller::Admin::DB->index.");
}

sub schema : Local Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( schema => $c->model("DBIC")->schema );
}

sub dump : Local Args(0) {
    my ( $self, $c ) = @_;

    my $ok = eval {
        use Archive::Zip ();
        1;
    };

    unless ( $ok == 1 )
    {
        die "No Archive::Zip";
    }
    my $zip = Archive::Zip->new();

    my $schema = $c->model("DBIC")->schema;
    for my $source ( $schema->sources )
    {
        eval {
            my $rs = $schema->resultset($source);
            $rs->result_class("DBIx::Class::ResultClass::HashRefInflator");
            my $member = $zip->addString(encode_json([$rs->all]),
                                         "$source.json" );
            $member->desiredCompressionMethod(8);

#            push @{$c->stash->{rows}}, $rs->all();
        };
    }

    use IO::Scalar;
    my $body = "";
    my $fh = IO::Scalar->new(\$body);
    unless ( $zip->writeToFileHandle( $fh ) == 0 ) {
        die "asdfasdfasdf";
    }

    $c->response->content_type("application/zip");
    my $filename = $c->name . ".zip";
    $filename =~ s/"/\\"/g;
    $c->response->header('Content-Disposition' => qq[attachment; filename="$filename"]);
#    $c->response->content_type("text/plain");
    $c->response->write($body);
}

sub load : Local Args(0) {
    my ( $self, $c ) = @_;

}


1;

__END__

=head1 NAME

Yesh::Controller::Admin::DB - Catalyst Controller

=head1 METHODS

=over 4

=item 321

=back

=head1 LICENSE, AUTHOR, COPYRIGHT, SEE ALSO

L<Yesh::Manual> and L<Yesh>.

=cut
