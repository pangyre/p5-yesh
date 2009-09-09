package Yesh;
use strict;
use warnings;
use Catalyst::Runtime 5.80;
use parent "Catalyst";
use Catalyst qw(
                Unicode
                ConfigLoader
                Static::Simple
                Session
                Session::Store::FastMmap
                Session::State::Cookie
                Authentication
                Authorization::Roles
                +CatalystX::Plugin::Blurb

                RequireSSL
             );
use Moose;

our $AUTHORITY = "cpan:ASHLEY";
our $VERSION = "2.9012";

__PACKAGE__->config
    ( name => "Yesh/$VERSION",
      #setup_components => { except => qr/[.\#]/ },
      #"Model::DBIC" => { connect_info => 1 },
      session => {
          verify_address => 1,
          rewrite => 0,
          storage => __PACKAGE__->path_to("tmp/session-$<.fmp")->stringify,
      },
      static => {
          include_path => [ __PACKAGE__->path_to('root', 'static') ],
          ignore_extensions => [], # Turns all others, like html, on.
      },
    );

sub name : method {
    my $c = shift;
    $c->{name} ||= $c->config->{name};
}

sub version : method {
    $VERSION;
}

has "repository" => 
    is => "ro",
    isa => "Str",
    default => "http://github.com/pangyre/p5-yesh";

__PACKAGE__->setup();

__PACKAGE__->meta->make_immutable( replace_constructor => 1 );

13;

__END__

=head1 NAME

Yesh - yet another CMS.

=head1 SYNOPSIS

    script/yesh_server.pl

=head1 DESCRIPTION

This is the technical and license doc. Normal end-users will want to read L<Yesh::Manual> instead.

=head1 TO DO

Support for setting L<Catalyst::Plugin::RequireSSL> on login and article edits?

Pod viewer.

Move C<config-E<gt>{configured}> to a third config file to separate it from direct user interaction?

=head1 CODE REPOSITORY

L<http://github.com/pangyre/p5-yesh>.

=head1 SEE ALSO

L<Yesh::Controller::Root>, L<Catalyst>.

=head1 AUTHOR

Ashley Pond V, <ashley@cpan.org>.

=head1 LICENSE

This library is free software. You can redistribute and modify it
under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

Because this software is licensed free of charge, there is no warranty
for the software, to the extent permitted by applicable law. Except when
otherwise stated in writing the copyright holders and other parties
provide the software "as is" without warranty of any kind, either
expressed or implied, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose. The
entire risk as to the quality and performance of the software is with
you. Should the software prove defective, you assume the cost of all
necessary servicing, repair, or correction.

In no event unless required by applicable law or agreed to in writing
will any copyright holder, or any other party who may modify or
redistribute the software as permitted by the above license, be
liable to you for damages, including any general, special, incidental,
or consequential damages arising out of the use or inability to use
the software (including but not limited to loss of data or data being
rendered inaccurate or losses sustained by you or third parties or a
failure of the software to operate with any other software), even if
such holder or other party has been advised of the possibility of
such damages.

=cut

1;
