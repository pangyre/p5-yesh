package Yesh::Schema::Result::License;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("license");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "title",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "uri",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "display",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
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
__PACKAGE__->add_unique_constraint("title", ["title"]);
__PACKAGE__->add_unique_constraint("uri", ["uri"]);
__PACKAGE__->has_many(
  "article_licenses",
  "Yesh::Schema::Result::Article",
  { "foreign.license" => "self.id" },
);
__PACKAGE__->has_many(
  "article_live_licenses",
  "Yesh::Schema::Result::Article",
  { "foreign.live_license" => "self.id" },
);
__PACKAGE__->has_many(
  "comments",
  "Yesh::Schema::Result::Comment",
  { "foreign.license" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-12 14:52:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:slxoLMZyWlyYXIACNDVQ0w

__PACKAGE__->utf8_columns( __PACKAGE__->columns );

1;
