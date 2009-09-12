package Yesh::Schema::Result::Template;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("template");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "uuid",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 36 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "body",
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
__PACKAGE__->has_many(
  "articles",
  "Yesh::Schema::Result::Article",
  { "foreign.template" => "self.id" },
);
__PACKAGE__->has_many(
  "display_groups",
  "Yesh::Schema::Result::DisplayGroup",
  { "foreign.template" => "self.id" },
);
__PACKAGE__->has_many(
  "fragments",
  "Yesh::Schema::Result::Fragment",
  { "foreign.template" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-12 14:52:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bSPV8jZ8mTBi25Xy3qWvxA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
