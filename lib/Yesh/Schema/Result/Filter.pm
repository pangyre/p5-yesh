package Yesh::Schema::Result::Filter;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("filter");
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
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 36 },
  "name",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => 65535,
  },
  "code",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => 65535,
  },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "description_type",
  {
    data_type => "ENUM",
    default_value => "plain",
    extra => { list => ["markdown", "pod", "plain", "xhtml"] },
    is_nullable => 1,
    size => 8,
  },
  "core",
  {
    data_type => "ENUM",
    default_value => 0,
    extra => { list => [0, 1] },
    is_nullable => 0,
    size => 1,
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
  "fragment_filters",
  "Yesh::Schema::Result::FragmentFilter",
  { "foreign.filter" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 19:50:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:49KUcer03HFyxVMYWkw0iw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
