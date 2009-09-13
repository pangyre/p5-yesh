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
our $VERSION = "2.9020";

__PACKAGE__->config
    ( name => "Yesh/$VERSION",
      #setup_components => { except => qr/[.\#]/ },
      "Plugin::ConfigLoader" => { file => __PACKAGE__->path_to("conf") },
      "Plugin::Session" => {
          # verify_address => 1,
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

Yesh - YACMS: secure, multi-author, modern, flexible, friendly, L<Catalyst>-based (alpha software).

=head1 DESCRIPTION

This is the technical and license doc. Normal end-users will want to read B<L<Yesh::Manual>> instead. Yesh is yet another content management system.

=over 4

=item Secure

Well, we take it seriously anyway. This is an unfinished application and may have security bugs; plus it is meant to be an easy to install, user-administered application which leaves file and basic system security in the hands of the user running the application.

That said, the passwords are stored as an expensive L<Crypt::Eksblowfish::Bcrypt> hash. The application supports forcing users to register and sign in under https. If configured correctly Yesh will be among the most secure, if not I<the> most secure, FOSS (free and open source software) personal publishing platform.

=item Modern

It is highly introspective: status, documentation, underlying software, and database information can be examined within the application.

It follows modern software standards and uses modern kits: L<Catalyst>, L<DBIx::Class>, and L<Template> Toolkit drive Yesh.

We will not call it 3.0 and ready for production until it has thorough test coverage and code documentation.

=item Multi-author

Content (articles) can be written by one or several users. Users can open their own content for collaboration or protect it. An editorial role can be given to a user who can then edit content of certain other users.

=item Flexible

Yesh should run on no less than three database enginesE<mdash>SQLite, MySQL, and PostgreSQLE<mdash>and may even run on others without changes. Yesh may be deployed to its native server (not recommended), modperl, and FastCGI (recommended) on any OS which can run L<Catalyst>.

=back

=head1 SYNOPSIS

    script/yesh_server.pl

=head1 TO DO

Tests.

Manual complete.

Article revision views.

Move C<config-E<gt>{configured}> to a third config file to separate it from direct user interaction?

Move the entire auto-config to a third config file?

=head1 CODE REPOSITORY

L<http://github.com/pangyre/p5-yesh>.

=head1 SEE ALSO

L<Yesh::Manual>, L<Catalyst>.

=head1 AUTHOR

Ashley Pond V E<middot> ashley.pond.v@gmail.com E<middot> L<http://pangyresoft.com>.

=head1 LICENSE

The parts of this library which is Yesh specific is free software. You
can redistribute and modify it under the same terms as Perl itself.

Some third party software, e.g. jQuery, may also included in this distribution. Please see L<Yesh::Manual::ThirdParty> for more about that.

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
