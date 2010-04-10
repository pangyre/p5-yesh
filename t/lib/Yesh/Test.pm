package Yesh::Test;
use parent qw( Test::Class );
use Moose;
BEGIN { $ENV{YESH_CONFIG_LOCAL_SUFFIX} ||= "test" }

no Moose;

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

__END__

=pod

=head1 NAME

Yesh::Test - L<Test::Class> subclass to use as master for all tests.

=head1 SYNOPSIS

 # something...

=head1 COPYRIGHT AND LICENSE

See L<Yesh>.

=cut
