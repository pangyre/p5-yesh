package Yesh::Schema::Result::Role;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("role");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BINARY", default_value => "", is_nullable => 0, size => 36 },
  "name",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 40 },
  "description",
  { data_type => "TEXT", default_value => "", is_nullable => 0, size => 65535 },
  "created",
  { data_type => "DATETIME", default_value => "", is_nullable => 0, size => 19 },
  "updated",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("name", ["name"]);


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-01-10 18:35:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sVPDxkbrhOUkrUg3BYlyHA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
