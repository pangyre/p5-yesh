package Yesh::View::Alloy;
use strict;
use warnings;
no warnings "uninitialized";
use parent "Catalyst::View::TT::Alloy";
use Scalar::Util "blessed";
use JSON::XS ();
use Number::Format;
use Encode;

__PACKAGE__->config
    (
     ENCODING => 'UTF-8',
     RECURSION => 1,
     FILTERS => {
         commify => sub {
             return Number::Format::format_number(shift);
         },
     },
     DUMP => {
         handler => sub {
             require YAML;
             YAML::Dump(shift);
#             # return _yesh_dumper(+shift);
         },
     }
    );

Template::Alloy->define_vmethod
    (
     "LIST",
     serial => sub {
         my @list = @{ +shift || [] };
         join(", ", @list[0..$#list-1]) .
             (@list>2 ? ",":"" ) .
             (@list>1 ? (" and " . $list[-1]) : $list[-1]);
     }
     );

Template::Alloy->define_vmethod
    ("HASH",
     encode_json => sub {
         my $hash = shift || return "{}";
         if ( blessed($hash) eq "DBIx::Class::ResultSet" )
         {
             $hash->result_class("DBIx::Class::ResultClass::HashRefInflator");
             Encode::decode_utf8(JSON::XS::encode_json({ map { $_->{id} => $_ } $hash->all }));
         }
         elsif ( ref($hash) eq "HASH" )
         {
             Encode::decode_utf8(JSON::XS::encode_json($hash) );
         }
         else
         {
             die "Don't know what to do with $hash";
         }
     });

sub _yesh_dumper {
    my $thing = shift;
    if ( ref($thing) eq 'HASH' )
    {
        for my $key ( sort keys %$thing )
        {
            return $key, _yesh_dumper($thing->{$key});
        }
    }
    elsif (  ref($thing) eq 'ARRAY' )
    {

    }
    elsif (  ref($thing) eq 'SCALAR' )
    {

    }
    else
    {
        return $thing;
    }
}

1;

__END__

=head1 NAME

Yesh::View::Alloy - L<Template::Alloy> based TT2 emulation view layer for L<Yesh>.

=head1 FILTERS

=over 4

=item commify

Calls L<format_number|Number::Format> in L<Number::Format>.

=back

=head1 VMETHODS

=over 4

=item serial

Serial comma join on a list.

  [% [ "one", "two", "three" ].serial() %]
  one, two, and three.

=item encode_json

Encodes hash or array references into JSON. Uses L<JSON::XS>.

=back

=head1 MACROS

=over 4

=item perldoc_link

Takes a module name and optional desired link text. Returns a search.cpan.org/perldoc?Module::Name style anchor tag.

 [% perldoc_link("DBD::Pg","PostgreSQL") %]
 <a href="http://search.cpan.org/perldoc?DBD::Pg" title="PostgreSQL">PostgreSQL</a>

=item user_uri

Takes a L<Yesh::Schema::Result::User> object. Returns a URI to view the user.

=item user_link

Creates an anchor tag with the C<user_uri> and the user's name.

=item edit_article_button(a,class)

=item article_uri(a)

=item article_link(a) 

=back

=head1 LICENSE, AUTHOR, COPYRIGHT, SEE ALSO

L<Yesh::Manual>.

=cut
