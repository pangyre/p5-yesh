package Yesh::Test::C::Root;
use parent "Yesh::Test";
use Moose;
with qw( Yesh::MechCat );

#sub oh_hai : Test(startup) {
#}

#sub per_test : Test(setup) {
#    die;
#}

sub home : Test(4) {
    my $self = shift;
    $self->get_ok("/", "Get /");
    $self->title_like(qr/Articles.+?Yesh/, "Page title looks good");
    $self->content_like(qr/(log|sign).?in/i, "Sign-in is present");
    # $self->content_like(qr/Copyright\D+\d{4}/, "Copyright appears in page");
    $self->content_like(qr/License.+?Artistic 2.0/s, "License appears in page");
}

#sub moo : Test(teardown) {
#}

#sub goo : Test(shutdown) {
#}

1;

__END__

=pod

=head1 Run this test package

 perl -Ilib -It/lib -MYesh::Test::C::Root -e "Yesh::Test::C::Root->runtests"

=cut

Consider putting a teardown in *every* test class to check for disclaimer?

