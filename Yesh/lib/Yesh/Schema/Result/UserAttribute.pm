package Yesh::Schema::Result::UserAttribute;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("user_attribute");
__PACKAGE__->add_columns(
  "user",
  {
    data_type => "INT",
    default_value => "",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "attribute",
  {
    data_type => "INT",
    default_value => "",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "value",
  {
    data_type => "MEDIUMTEXT",
    default_value => "",
    is_nullable => 0,
    size => 16777215,
  },
);
__PACKAGE__->set_primary_key("user", "attribute");
__PACKAGE__->belongs_to("user", "Yesh::Schema::Result::User", { id => "user" });
__PACKAGE__->belongs_to(
  "attribute",
  "Yesh::Schema::Result::Attribute",
  { id => "attribute" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-03-14 13:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SjToEjW2HOghK/B8e9mJBQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
