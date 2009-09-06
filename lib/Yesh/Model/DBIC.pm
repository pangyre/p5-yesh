package Yesh::Model::DBIC;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Yesh::Schema',
    
);

=head1 NAME

Yesh::Model::DBIC - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<Yesh>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Yesh::Schema>

=head1 AUTHOR

apv

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
