package Yesh::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
    size => 10,
  },
  "uuid",
  { data_type => "CHAR", default_value => "", is_nullable => 0, size => 36 },
  "username",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 80 },
  "password",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 60 },
  "email",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 100 },
  "status",
  {
    data_type => "ENUM",
    default_value => "registered",
    extra => { list => ["registered", "active", "blocked", "deleted"] },
    is_nullable => 0,
    size => 10,
  },
  "created",
  { data_type => "DATETIME", default_value => "", is_nullable => 0, size => 19 },
  "updated",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("email", ["email"]);
__PACKAGE__->add_unique_constraint("username", ["username"]);
__PACKAGE__->has_many(
  "article_authors",
  "Yesh::Schema::Result::ArticleAuthor",
  { "foreign.author" => "self.id" },
);
__PACKAGE__->has_many(
  "comments",
  "Yesh::Schema::Result::Comment",
  { "foreign.user" => "self.id" },
);
__PACKAGE__->has_many(
  "user_article_roles",
  "Yesh::Schema::Result::UserArticleRole",
  { "foreign.user" => "self.id" },
);
__PACKAGE__->has_many(
  "user_attributes",
  "Yesh::Schema::Result::UserAttribute",
  { "foreign.user" => "self.id" },
);
__PACKAGE__->has_many(
  "user_site_roles",
  "Yesh::Schema::Result::UserSiteRole",
  { "foreign.user" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-09-12 16:40:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qs4Rd6p80JdSek0N79zZug

use List::Util "first";
use Scalar::Util "blessed";

BEGIN { use base "DBIx::Class";
        __PACKAGE__->load_components("EncodedColumn",
                                     "InflateColumn::DateTime",
                                    );
             }

__PACKAGE__->many_to_many(site_roles => 'user_site_roles', 'site_role');
__PACKAGE__->many_to_many(article_roles => 'user_article_roles', 'article_role');
__PACKAGE__->utf8_columns( __PACKAGE__->columns );

__PACKAGE__->add_columns(
                         created => { data_type => 'datetime' },
                         updated => { data_type => 'datetime' },
                         );

__PACKAGE__->add_columns(
    password => {
        encode_column => 1,
        encoded_column => 1,
        data_type => "VARCHAR",
        is_nullable => 0,
        size        => 60,
        encode_class  => "Crypt::Eksblowfish::Bcrypt",
        encode_args   => { key_nul => 1,
                           cost => 10 },
        encode_check_method => "check_password",
    }); 

sub can_preview_article {
    my $self = shift;
    my $article = shift;
    return 1 if $article->user->id eq $self->id;
    # Next check roles? Levels?
    return;
}

=item has_site_role

Takes a role object, an id, or a name.

=cut

sub has_site_role : method {
    my $self = shift;
    my $role = shift || return;

    if ( blessed $role )
    {
        return first { $role->id == $_->id } $self->site_roles;
    }
    elsif ( $role =~ /\A\d+\z/ )
    {
        return first { $role == $_->id } $self->site_roles;
    }
    else
    {
        return first { $role eq $_->name } $self->site_roles;
    }
    return;
}


1;

__END__



  sub _role_to_id {
    my ($self, $role) = @_;
    return blessed($role) ? $role->id : $role;
}
sub with_any_role {
    my ( $self, @roles ) = @_;
    $self->search({
        'role_links.role_id' => {
          -in => [
            map { $self->_role_to_id($_) } @roles
          ]
        }
      },
      { join => 'role_links' }
    );
  }
----


