package Yesh::Schema::Result::Fragment;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("fragment");
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
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 36 },
  "author",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 10,
  },
  "template",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
    size => 10,
  },
  "css_class",
  {
    data_type => "TINYTEXT",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "body",
  {
    data_type => "MEDIUMTEXT",
    default_value => undef,
    is_nullable => 0,
    size => 16777215,
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
__PACKAGE__->has_many(
  "article_fragments",
  "Yesh::Schema::Result::ArticleFragment",
  { "foreign.fragment" => "self.id" },
);
__PACKAGE__->belongs_to(
  "template",
  "Yesh::Schema::Result::Template",
  { id => "template" },
  { join_type => "LEFT" },
);
__PACKAGE__->has_many(
  "fragment_filters",
  "Yesh::Schema::Result::FragmentFilter",
  { "foreign.fragment" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 21:15:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wTZUS0x8eKV2lONuSU84wQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
