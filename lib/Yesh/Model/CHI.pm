package Yesh::Model::CHI;
use strict;
use warnings;
use parent "Catalyst::Model::Adaptor";

sub mangle_arguments {
    my ( $self, $args) = @_;
    return %{$args};
}

1;

__END__

=head1 NAME

Yesh::Model::CHI - Catalyst Model

=head1 METHODS

=over 4

=item 321

=back

=head1 LICENSE, AUTHOR, COPYRIGHT, SEE ALSO

L<Yesh::Manual> and L<Yesh>.

=cut

