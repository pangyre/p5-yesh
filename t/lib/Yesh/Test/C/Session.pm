package Yesh::Test::C::Session;
use parent "Yesh::Test";
use Moose;
with qw( Yesh::MechCat );

#sub oh_hai : Test(startup) {
#}

#sub per_test : Test(setup) {
#    die;
#}

sub login : Test(3) {
    my $self = shift;
    $self->get_ok("/login", "Get /login");
    $self->title_like(qr/(log|sign).?in/i, "Page title looks good");
    $self->content_like(qr/(log|sign).?in/i, "Sign-in is present");
    # $self->content_like(qr/Copyright\D+\d{4}/, "Copyright appears in page");
    # $self->page_links_ok('Check all links');
}

sub logout : Test {
    my $self = shift;
}

#sub moo : Test(teardown) {
#}

#sub goo : Test(shutdown) {
#}

1;

__END__

=pod

=head1 Run this test package

 perl -Ilib -It/lib -MYesh::Test::C::Session -e "Yesh::Test::C::Session->runtests"

=cut

Consider putting a teardown in *every* test class to check for disclaimer?

