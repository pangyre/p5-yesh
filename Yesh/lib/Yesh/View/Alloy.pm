package Yesh::View::Alloy;
use strict;
use warnings;
no warnings "uninitialized";
use parent "Catalyst::View::TT::Alloy";
use Scalar::Util "blessed";
use JSON::XS ();

__PACKAGE__->config
    (
     ENCODING => 'UTF-8',
     FILTERS => {
         commify => sub {
             my $text = reverse $_[0];
             $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
             return scalar reverse $text;
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

Yesh::View::Alloy

=head1 SEE ALSO

L<http://search.cpan.org/perldoc?Catalyst::View::TT::Alloy>, L<http://search.cpan.org/perldoc?Templat
e::Alloy>.

=cut
