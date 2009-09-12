package Yesh::Schema::Result::DisplayGroup;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("display_group");
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
  "template",
  {
    data_type => "INT",
    default_value => "",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "name",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
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
__PACKAGE__->has_many(
  "article_display_groups",
  "Yesh::Schema::Result::ArticleDisplayGroup",
  { "foreign.display_group" => "self.id" },
);
__PACKAGE__->belongs_to(
  "template",
  "Yesh::Schema::Result::Template",
  { id => "template" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-09-12 16:40:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/FjNAPDlXxr+zkct0Kq/Rg

__PACKAGE__->many_to_many(articles => "article_display_groups", "article");

1;
