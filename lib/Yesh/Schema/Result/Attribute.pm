package Yesh::Schema::Result::Attribute;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("attribute");
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
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");
#__PACKAGE__->add_unique_constraint("attribute", ["name"]);
__PACKAGE__->add_unique_constraint(["name"]);
__PACKAGE__->has_many(
  "user_attributes",
  "Yesh::Schema::Result::UserAttribute",
  { "foreign.attribute" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 21:15:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7zkfLbtNPYhBUIq9QshDeQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
