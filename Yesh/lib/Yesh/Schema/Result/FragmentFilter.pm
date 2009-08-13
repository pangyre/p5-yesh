package Yesh::Schema::Result::FragmentFilter;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("fragment_filter");
__PACKAGE__->add_columns(
  "fragment",
  {
    data_type => "INT",
    default_value => "",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "filter",
  {
    data_type => "INT",
    default_value => "",
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
  { data_type => "DATETIME", default_value => "", is_nullable => 0, size => 19 },
  "updated",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("fragment", "filter");
__PACKAGE__->belongs_to(
  "fragment",
  "Yesh::Schema::Result::Fragment",
  { id => "fragment" },
);
__PACKAGE__->belongs_to("filter", "Yesh::Schema::Result::Filter", { id => "filter" });


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-03-14 13:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oLshBLnq1Gd7vG4MTCYLeQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
