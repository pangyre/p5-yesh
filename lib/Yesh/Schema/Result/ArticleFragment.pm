package Yesh::Schema::Result::ArticleFragment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("Yesh::Default", "InflateColumn::DateTime");

=head1 NAME

Yesh::Schema::Result::ArticleFragment

=cut

__PACKAGE__->table("article_fragment");

=head1 ACCESSORS

=head2 article

  data_type: INT
  default_value: undef
  extra: HASH(0xa1d480)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 fragment

  data_type: INT
  default_value: undef
  extra: HASH(0xa27170)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 priority

  data_type: INT
  default_value: 1
  extra: HASH(0xa218b0)
  is_nullable: 0
  size: 2

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
  "fragment",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "priority",
  {
    data_type => "INT",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 2,
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
__PACKAGE__->set_primary_key("article", "fragment");

=head1 RELATIONS

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

=head2 fragment

Type: belongs_to

Related object: L<Yesh::Schema::Result::Fragment>

=cut

__PACKAGE__->belongs_to(
  "fragment",
  "Yesh::Schema::Result::Fragment",
  { id => "fragment" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-17 21:06:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KF9Fj6cCm10dlcLxehAaRA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
