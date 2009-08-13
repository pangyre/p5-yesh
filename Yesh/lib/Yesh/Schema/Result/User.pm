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
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "email",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 100 },
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
  "articles",
  "Yesh::Schema::Result::Article",
  { "foreign.user" => "self.id" },
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


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-03-14 13:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FNP0mllDvCCRpvt/fJsMeQ

__PACKAGE__->many_to_many(site_roles => 'user_site_roles', 'site_role');
__PACKAGE__->many_to_many(article_roles => 'user_article_roles', 'article_role');
__PACKAGE__->utf8_columns( __PACKAGE__->columns );

__PACKAGE__->add_columns(
                         created => { data_type => 'datetime' },
                         updated => { data_type => 'datetime' },
                         );

sub can_preview_article {
    my $self = shift;
    my $article = shift;
    return 1 if $article->user->id eq $self->id;
    # Next check roles? Levels?
    return;
}

1;
