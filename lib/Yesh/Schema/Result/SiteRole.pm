package Yesh::Schema::Result::SiteRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("site_role");
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
  "name",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 40 },
  "description",
  { data_type => "TEXT", default_value => "", is_nullable => 0, size => 65535 },
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
__PACKAGE__->add_unique_constraint("name", ["name"]);
__PACKAGE__->has_many(
  "user_site_roles",
  "Yesh::Schema::Result::UserSiteRole",
  { "foreign.site_role" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-03-14 13:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U6BZ4ks4PHOdlkzYwCibYA

# use overload q{""} => "name", fallback => 1;

# You can replace this text with custom content, and it will be preserved on regeneration
1;
