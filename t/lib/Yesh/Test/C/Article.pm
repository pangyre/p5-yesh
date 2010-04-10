package Yesh::Test::C::Article;
use parent "Yesh::Test";
use Moose;
with qw( Yesh::MechCat );

#sub oh_hai : Test(startup) {
#}

#sub per_test : Test(setup) {
#    die;
#}

sub article : Test(1) {
    my $self = shift;
    $self->get_ok("/a", "Get /a");
    # $self->title_like(qr/Articles/, "Page title looks good");
    # $self->content_like(qr/(log|sign).?in/i, "Sign-in is present");
    # $self->content_like(qr/Copyright\D+\d{4}/, "Copyright appears in page");
    # $self->page_links_ok('Check all links');
}

sub article_view : Tests() {
    my $self = shift;
}

sub article_atom : Tests() {
    my $self = shift;
}

sub article_edit : Tests() {
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

 perl -Ilib -It/lib -MYesh::Test::C::Article -e "Yesh::Test::C::Article->runtests"

=cut

Consider putting a teardown in *every* test class to check for disclaimer?

