package Yesh::Schema::Result::ArticleDisplayGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("Yesh::Default", "InflateColumn::DateTime");

=head1 NAME

Yesh::Schema::Result::ArticleDisplayGroup

=cut

__PACKAGE__->table("article_display_group");

=head1 ACCESSORS

=head2 article

  data_type: INT
  default_value: undef
  extra: HASH(0xa1b270)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 display_group

  data_type: INT
  default_value: undef
  extra: HASH(0xa1d360)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 created

  data_type: DATETIME
  default_value: undef
  is_nullable: 0
  size: 19

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
  "display_group",
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
);
__PACKAGE__->set_primary_key("article", "display_group");

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

=head2 display_group

Type: belongs_to

Related object: L<Yesh::Schema::Result::DisplayGroup>

=cut

__PACKAGE__->belongs_to(
  "display_group",
  "Yesh::Schema::Result::DisplayGroup",
  { id => "display_group" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-17 21:06:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xXf++mAmPQe2h3hDtYZiIQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
