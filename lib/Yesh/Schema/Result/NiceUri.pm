package Yesh::Schema::Result::NiceUri;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("nice_uri");
__PACKAGE__->add_columns(
  "article",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 10,
  },
  "path",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
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
__PACKAGE__->set_primary_key("article", "path");


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 19:50:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:x82Rxd+I0gcKyDX/LI72ZA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
