package DBIx::Class::Yesh::Default;
use parent "DBIx::Class::Row";
use strict;
use Data::UUID;
use Digest::SHA1;
use Date::Calc;
no warnings "uninitialized";
use DBIx::Class::Exception;
use Encode;
my $null = \'NULL'; # '
my $now = \'NOW'; # '

sub insert {
    my $self = shift;
    $self->uuid( lc Data::UUID->new->create_str )
        if $self->has_column("uuid") and not $self->uuid;
    my $now = sprintf("%4d-%02d-%02d %02d:%02d:%02d", Date::Calc::Today_and_Now());
    $self->created($now)
        if $self->has_column("created") and not $self->created;
    $self->golive($now)
        if $self->has_column("golive") and not $self->golive;
    $self->takedown("9999-01-01 00:00:01") # "Never"
        if $self->has_column("takedown") and not $self->takedown;

    $self->updated($now)
        if $self->has_column("updated") and not $self->updated;

    # Nothing gets inserted without a password!
#    $self->password($self->password) if $self->can("password");
#    $self->password(Digest::SHA1::sha1_hex(Encode::encode("utf-8",$self->password)))
#        if $self->can("password");

    for my $col ( $self->columns )
    {
        $self->$col($null)
            if 0 == length($self->$col);
    }
    $self->validate if $self->can("validate");
    return $self->next::method(@_);
}

sub update {
    my $self = shift;
    my %to_update = $self->get_dirty_columns;
    return $self->next::method(@_) unless keys %to_update;
    for my $col ( keys %to_update )
    {
        DBIx::Class::Exception->throw("UUIDs may never be changed!") if lc($col) eq "uuid";
        next unless $to_update{$col} eq "" or not defined $to_update{$col};
        my $info = $self->result_source->column_info($col);
        DBIx::Class::Exception->throw("Column '$col' in " . $self->table . " cannot be null")
            unless $info->{is_nullable};
        $self->{_column_data}{$col} = $null;
    }
    $self->validate if $self->can("validate");
    return $self->next::method(@_);
}

sub token {
    Digest::SHA1::sha1_hex(Encode::encode("utf-8",
                                          join("", +shift->get_columns)
                                          )
                           );
} 

1;


__END__

=pod

=head1 NAME

DBIx::Class::Yesh::Default - Routines to set defaults, extend row classes, and call validation methods on insert and update.

=cut

Should allow them to be set. If none is set then default to finding them automatically.

Created...? Check any that are datetime which aren't set and stamp them now()?

head2 is_same_row

 if ( $obj1->is_same_row($obj2) ) {
     print "Objects 1 and 2 are the same record\n";
 }

And maybe an additional arg to do a "deep" check by refreshing objects and comparing all their data(?).

 $obj1->is_same_row($obj2,1)

sub is_same_row {
    my $self = shift;
    my $other = shift || return;
    my @pk1 = $self->id;  # Are these returned in reliable order?
    my @pk2 = $other->id;
    return unless @pk1 == @pk2;
    return unless blessed($self) eq blessed($other);
    for ( 0 .. $#pk1  ) {
        return unless "$pk1[$_]" eq "$pk2[$_]";
    }
    return 1;
}



    for my $col ( $self->columns )
    {
        next unless $self->$col eq "" or ! defined $self->$col;
        # Skip if the DB has a default for an empty field-
#        my $info = $self->result_source->column_info($col);
#        next if $info->{default_value} and $info->{is_nullable};
        # Otherwise, make it right-
        $self->$col($null);
    }
