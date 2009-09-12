package Yesh::Schema::Result::ArticleTag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("article_tag");
__PACKAGE__->add_columns(
  "article",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "tag",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
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
__PACKAGE__->set_primary_key("tag", "article");
__PACKAGE__->belongs_to("tag", "Yesh::Schema::Result::Tag", { id => "tag" });
__PACKAGE__->belongs_to(
  "article",
  "Yesh::Schema::Result::Article",
  { id => "article" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-12 14:52:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vy1fj4DLyqBdMB9nfYlucg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
