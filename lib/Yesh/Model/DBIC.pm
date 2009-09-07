package Yesh::Model::DBIC;
use strict;
use parent 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Yesh::Schema',
    );

1;

__END__

=head1 NAME

Yesh::Model::DBIC - Catalyst DBIC Schema Model using L<Yesh::Schema> as its C<schema_class>.

=head1 REFER TO

L<Yesh::Manual> and L<Yesh>.

=cut
