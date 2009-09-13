package Yesh::Schema::Result::Article;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("article");
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
  "user",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "parent",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
    size => 10,
  },
  "template",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
    size => 10,
  },
  "license",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "title",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => 65535,
  },
  "body",
  {
    data_type => "MEDIUMTEXT",
    default_value => undef,
    is_nullable => 0,
    size => 16777215,
  },
  "note",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "status",
  {
    data_type => "ENUM",
    default_value => "draft",
    extra => { list => ["draft", "publish", "resource", "manual", "deleted"] },
    is_nullable => 1,
    size => 8,
  },
  "comment_flag",
  {
    data_type => "ENUM",
    default_value => "on",
    extra => { list => ["on", "off", "closed", "hide"] },
    is_nullable => 1,
    size => 6,
  },
  "live_license",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
    size => 10,
  },
  "golive",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "takedown",
  {
    data_type => "DATETIME",
    default_value => "9999-12-31 00:00:00",
    is_nullable => 0,
    size => 19,
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


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 19:51:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oq/5AneZVu9PQDIXg5Vgsg

# use Date::Calc ();
use DateTime ();
use DBIx::Class::Exception ();

__PACKAGE__->many_to_many(display_groups => "article_display_groups", "display_group");

__PACKAGE__->utf8_columns( __PACKAGE__->columns );

sub is_live {
    my $self = shift;
    return unless ref $self;
    my $now = DateTime->now();

    for my $check ( $self, $self->parents )
    {
        return unless
            $check->status eq 'publish'
            and
            $check->golive lt $now
            and
            $check->takedown gt $now;
    }
    1;
}

sub parents {
    my ( $self, @parents ) = @_;
    my $parent = $self->parent;
    return @parents unless $parent;
    unshift @parents, $parent;
    die "Unterminating lineage loop suspected!" if @parents > 50;
    $parent->parents(@parents);
}

sub depth {
    my $self = shift;
    scalar $self->parents;
}

sub root {
    my $self = shift;
    my @parents = $self->parents;
    return $parents[0];
}

sub validate {
    my $self = shift;
    my @message;
    push @message, "golive date cannot be greater than takedown date"
        unless $self->get_column("golive") lt $self->get_column("takedown");
    push @message, "parent cannot reference self"
        if $self->in_storage
        and
        $self->get_column("parent") eq $self->get_column("id");
    DBIx::Class::Exception->throw(@message) if @message;
    1;
}

# Deal with live_license here...? Set ONCE when it's live anyway.
#sub update {
#    my $self = shift;
#    my %to_update = $self->get_dirty_columns;
#    if ( $self->is_live and 
#}


1;
