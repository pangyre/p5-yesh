package Yesh::Schema::Result::ArticleTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("Yesh::Default", "InflateColumn::DateTime");

=head1 NAME

Yesh::Schema::Result::ArticleTag

=cut

__PACKAGE__->table("article_tag");

=head1 ACCESSORS

=head2 article

  data_type: INT
  default_value: undef
  extra: HASH(0xa1d710)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 tag

  data_type: INT
  default_value: undef
  extra: HASH(0xa1bc60)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

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
  "article",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "tag",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
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
__PACKAGE__->set_primary_key("tag", "article");

=head1 RELATIONS

=head2 tag

Type: belongs_to

Related object: L<Yesh::Schema::Result::Tag>

=cut

__PACKAGE__->belongs_to("tag", "Yesh::Schema::Result::Tag", { id => "tag" }, {});

=head2 article

Type: belongs_to

Related object: L<Yesh::Schema::Result::Article>

=cut

__PACKAGE__->belongs_to(
  "article",
  "Yesh::Schema::Result::Article",
  { id => "article" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-17 21:06:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3XaBaF9N+8rhJyjp3Nxjqg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
