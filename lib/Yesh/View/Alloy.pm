package Yesh::View::Alloy;
use strict;
use warnings;
no warnings "uninitialized";
use parent "Catalyst::View::TT::Alloy";
use Scalar::Util "blessed";
use JSON::XS ();
use Number::Format;

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
    ("LIST",
     encode_json => sub {
         my $rs = shift || return "[]";
         warn "$rs is not a DBIx::Class::ResultSet reference" && return "[]"
             unless blessed($rs) eq "DBIx::Class::ResultSet";
         $rs->result_class("DBIx::Class::ResultClass::HashRefInflator");
         JSON::XS::encode_json([$rs->all]);
     });

Template::Alloy->define_vmethod
    ("HASH",
     encode_json => sub {
         my $rs = shift || return "{}";
         warn "$rs is not a blessed DBIx::Class::ResultSet reference" and return "{}"
             unless blessed($rs) eq "DBIx::Class::ResultSet";
         $rs->result_class("DBIx::Class::ResultClass::HashRefInflator");
         JSON::XS::encode_json({ map { $_->{id} => $_ } $rs->all });
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

Yesh::View::Alloy - TT2 emulation view layer for L<Yesh>.

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

=head1 LICENSE, AUTHOR, COPYRIGHT, SEE ALSO

L<Yesh::Manual>.

=cut
