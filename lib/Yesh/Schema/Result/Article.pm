package Yesh::Schema::Result::Article;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("Yesh::Default", "InflateColumn::DateTime");

=head1 NAME

Yesh::Schema::Result::Article

=cut

__PACKAGE__->table("article");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  extra: HASH(0xa20de0)
  is_auto_increment: 1
  is_nullable: 0
  size: 10

=head2 uuid

  data_type: CHAR
  default_value: undef
  is_nullable: 0
  size: 36

=head2 user

  data_type: INT
  default_value: undef
  extra: HASH(0xa1de90)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 parent

  data_type: INT
  default_value: undef
  extra: HASH(0xa20e90)
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 template

  data_type: INT
  default_value: undef
  extra: HASH(0xa21130)
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 license

  data_type: INT
  default_value: undef
  extra: HASH(0xa21910)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 title

  data_type: TEXT
  default_value: undef
  is_nullable: 0
  size: 65535

=head2 body

  data_type: MEDIUMTEXT
  default_value: undef
  is_nullable: 0
  size: 16777215

=head2 note

  data_type: TEXT
  default_value: undef
  is_nullable: 1
  size: 65535

=head2 status

  data_type: ENUM
  default_value: draft
  extra: HASH(0xa1ae80)
  is_nullable: 1
  size: 8

=head2 comment_flag

  data_type: ENUM
  default_value: on
  extra: HASH(0xa1d6b0)
  is_nullable: 1
  size: 6

=head2 live_license

  data_type: INT
  default_value: undef
  extra: HASH(0xa22110)
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 golive

  data_type: DATETIME
  default_value: undef
  is_nullable: 0
  size: 19

=head2 takedown

  data_type: DATETIME
  default_value: 9999-12-31 00:00:00
  is_nullable: 0
  size: 19

=head2 created

  data_type: DATETIME
  default_value: undef
  is_nullable: 0
  size: 19

=head2 updated

  data_type: TIMESTAMP
  default_value: undef
  is_nullable: 1
  size: 14

=cut

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

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<Yesh::Schema::Result::User>

=cut

__PACKAGE__->belongs_to("user", "Yesh::Schema::Result::User", { id => "user" }, {});

=head2 parent

Type: belongs_to

Related object: L<Yesh::Schema::Result::Article>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "Yesh::Schema::Result::Article",
  { id => "parent" },
  { join_type => "LEFT" },
);

=head2 articles

Type: has_many

Related object: L<Yesh::Schema::Result::Article>

=cut

__PACKAGE__->has_many(
  "articles",
  "Yesh::Schema::Result::Article",
  { "foreign.parent" => "self.id" },
);

=head2 template

Type: belongs_to

Related object: L<Yesh::Schema::Result::Template>

=cut

__PACKAGE__->belongs_to(
  "template",
  "Yesh::Schema::Result::Template",
  { id => "template" },
  { join_type => "LEFT" },
);

=head2 license

Type: belongs_to

Related object: L<Yesh::Schema::Result::License>

=cut

__PACKAGE__->belongs_to(
  "license",
  "Yesh::Schema::Result::License",
  { id => "license" },
  {},
);

=head2 live_license

Type: belongs_to

Related object: L<Yesh::Schema::Result::License>

=cut

__PACKAGE__->belongs_to(
  "live_license",
  "Yesh::Schema::Result::License",
  { id => "live_license" },
  { join_type => "LEFT" },
);

=head2 article_display_groups

Type: has_many

Related object: L<Yesh::Schema::Result::ArticleDisplayGroup>

=cut

__PACKAGE__->has_many(
  "article_display_groups",
  "Yesh::Schema::Result::ArticleDisplayGroup",
  { "foreign.article" => "self.id" },
);

=head2 article_fragments

Type: has_many

Related object: L<Yesh::Schema::Result::ArticleFragment>

=cut

__PACKAGE__->has_many(
  "article_fragments",
  "Yesh::Schema::Result::ArticleFragment",
  { "foreign.article" => "self.id" },
);

=head2 article_tags

Type: has_many

Related object: L<Yesh::Schema::Result::ArticleTag>

=cut

__PACKAGE__->has_many(
  "article_tags",
  "Yesh::Schema::Result::ArticleTag",
  { "foreign.article" => "self.id" },
);

=head2 comment_articles

Type: has_many

Related object: L<Yesh::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comment_articles",
  "Yesh::Schema::Result::Comment",
  { "foreign.article" => "self.id" },
);

=head2 comment_parents

Type: has_many

Related object: L<Yesh::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comment_parents",
  "Yesh::Schema::Result::Comment",
  { "foreign.parent" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-17 21:06:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZQDT6162rN2EXwyuywgPIA

# use Date::Calc ();
use DateTime ();
use DBIx::Class::Exception ();

__PACKAGE__->many_to_many(display_groups => "article_display_groups", "display_group");

# __PACKAGE__->utf8_columns( __PACKAGE__->columns );

use XHTML::Util;
__PACKAGE__->inflate_column( body => {
    inflate => sub {
        my $body = Encode::decode_utf8(shift);
        XHTML::Util->new(\$body)
    },
    deflate => sub {
        +shift->as_string();
    },
                             });

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


1;

__END__

# Deal with live_license here...? Set ONCE when it's live anyway.
sub update {
    my $self = shift;
    my %to_update = $self->get_dirty_columns;
    if ( exists $to_update{parent} )
    {
        my 
    }
    return $self->next::method(@_);
}

sub insert {
    my $self = shift;
    my $position_column = $self->position_column;

    unless ($self->get_column($position_column)) {
        my $lsib_posval = $self->_last_sibling_posval;
        $self->set_column(
            $position_column => (defined $lsib_posval
                ? $self->_next_position_value ( $lsib_posval )
                : $self->_initial_position_value
            )
            );
    }

    return $self->next::method( @_ );
}

sub parents {
    my $self = shift;
    croak "parents is read only" if @_;
    my @ids = split '\.', $self->path;
    pop @ids; # remove self
    return unless @ids;
    return $self
        ->search( { 'me.id' => { -in => \@ids } },
                  { order_by => \"LENGTH me.path" } );
}

sub __parents {
    my ( $self, @parents ) = @_;
    my $parent = $self->parent;
    return @parents unless $parent;
    unshift @parents, $parent;
    die "Unterminating lineage loop suspected!" if @parents > 50;
    $parent->parents(@parents);
}

