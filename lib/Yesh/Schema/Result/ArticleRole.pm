package Yesh::Schema::Result::ArticleRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("Yesh::Default", "InflateColumn::DateTime");

=head1 NAME

Yesh::Schema::Result::ArticleRole

=cut

__PACKAGE__->table("article_role");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  extra: HASH(0xa1ddd0)
  is_auto_increment: 1
  is_nullable: 0
  size: 10

=head2 name

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 40

=head2 description

  data_type: TEXT
  default_value: undef
  is_nullable: 0
  size: 65535

=head2 created

  data_type: DATETIME
  default_value: undef
  is_nullable: 0
  size: 19

=head2 updated

  data_type: TIMESTAMP
  default_value: undef
  is_nullable: 1
  size: 14

=cut

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
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 40,
  },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => 65535,
  },
  "created",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "updated",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("name", ["name"]);

=head1 RELATIONS

=head2 user_article_roles

Type: has_many

Related object: L<Yesh::Schema::Result::UserArticleRole>

=cut

__PACKAGE__->has_many(
  "user_article_roles",
  "Yesh::Schema::Result::UserArticleRole",
  { "foreign.article_role" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-17 21:06:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4vh5xp1AdeqpcPDp5mnoQg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
