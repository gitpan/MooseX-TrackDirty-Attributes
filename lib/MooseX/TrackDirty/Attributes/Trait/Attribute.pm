#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Attribute;
{
  $MooseX::TrackDirty::Attributes::Trait::Attribute::VERSION = '0.90'; # TRIAL
}

# ABSTRACT: Track dirtied attributes

use Moose::Role;
use namespace::autoclean;
use MooseX::Types::Perl ':all';
use MooseX::AttributeShortcuts;

use v5.10;

# debugging
#use Smart::Comments '###', '####';

has is_dirty       => (is => 'ro', isa => Identifier, lazy => 1, builder => 1);
has original_value => (is => 'ro', isa => Identifier);

sub _build_is_dirty { shift->name . '_is_dirty' }
#...

has value_slot => (is => 'lazy', isa => 'Str');
has dirty_slot => (is => 'lazy', isa => 'Str');

sub _build_value_slot { shift->name                        }
sub _build_dirty_slot { shift->name . '__DIRTY_TRACKING__' }

override slots => sub { (super, shift->dirty_slot) };

before set_value => sub {
    my ($self, $instance) = @_;

    my $mi = $self->associated_class->get_meta_instance;

    my $_get    = sub { $mi->get_slot_value($instance, @_)      };
    my $_set    = sub { $mi->set_slot_value($instance, @_)      };
    my $_exists = sub { $mi->is_slot_initialized($instance, @_) };

    $_set->($self->dirty_slot, $_get->($self->value_slot))
        if $_exists->($self->value_slot) && !$_exists->($self->dirty_slot);

    return;
};

after clear_value => sub { shift->clear_dirty_slot(@_) };

around _inline_clear_value => sub {
    my ($orig, $self) = (shift, shift);
    my ($instance) = @_;

    my $mi = $self->associated_class->get_meta_instance;

    return $self->$orig(@_)
        . $mi->inline_deinitialize_slot($instance, $self->dirty_slot)
        . ';'
        ;
};

sub _inline_is_dirty_set {
    my $self = shift;
    my ($instance, $value) = @_;

    # set tracker if dirty_slot is not init and value_slot value_slot is

    my $mi = $self->associated_class->get_meta_instance;
    return $mi->inline_set_slot_value($instance, $self->dirty_slot, $value);
}

sub _inline_is_dirty_get {
    my $self = shift;
    my ($instance, $value) = @_;

    # set tracker if dirty_slot is not init and value_slot value_slot is

    my $mi = $self->associated_class->get_meta_instance;
    return $mi->inline_get_slot_value($instance, $self->dirty_slot, $value);
}

override _inline_instance_set => sub {
    my $self = shift;
    my ($instance, $value) = @_;
    # set dirty_slot from value_slot if dirty_slot is not init and value_slot value_slot is

    ### $instance
    ### $value

    my $mi = $self->associated_class->get_meta_instance;
    my $_exists = sub { $mi->inline_is_slot_initialized($instance, shift) };

    # use our predicate method if we have one, as it may have been wrapped/etc
    my $value_slot_exists
        = $self->has_predicate
        ? "${instance}->" . $self->predicate . '()'
        : $_exists->($self->value_slot)
        ;

    my $dirty_slot_exists = $_exists->($self->dirty_slot);

    my $set_dirty_slot = $self
        ->_inline_is_dirty_set(
            $instance,
            'do { ' .  $mi->inline_get_slot_value($instance, $self->value_slot) . ' } ',
        )
        ;

    my $code =
        "do { $set_dirty_slot } " .
        "   if $value_slot_exists && !$dirty_slot_exists;"
        ;

    $code = "do { $code; " . super . " }";

    ### $code
    return $code;
};

# TODO remove_accessors

sub mark_tracking_dirty { shift->set_dirty_slot(@_) }

sub original_value_get { shift->is_dirty_get(@_) }

sub is_dirty_set {
    my ($self, $instance) = @_;

    return $self
        ->associated_class
        ->get_meta_instance
        ->set_slot_value($instance, $self->dirty_slot)
        ;
}

sub is_dirty_get {
    my ($self, $instance) = @_;

    return $self
        ->associated_class
        ->get_meta_instance
        ->get_slot_value($instance, $self->dirty_slot)
        ;
}

sub is_dirty_instance {
    my ($self, $instance) = @_;

    return $self
        ->associated_class
        ->get_meta_instance
        ->is_slot_initialized($instance, $self->dirty_slot)
        ;
}

sub clear_dirty_slot {
    my ($self, $instance) = @_;

    return $self
        ->associated_class
        ->get_meta_instance
        ->deinitialize_slot($instance, $self->dirty_slot)
        ;
}

override accessor_metaclass => sub {
    my $self = shift @_;

    state $classname = Moose::Meta::Class->create_anon_class(
        superclasses => [ super ],
        roles        => [ 'MooseX::TrackDirty::Attributes::Trait::Method::Accessor' ],
        cache        => 1,
    )->name;

    return $classname;
};

after install_accessors => sub {
    my ($self, $inline) = @_;
    my $class = $self->associated_class;

    $class->add_method(
        $self->_process_accessors('is_dirty' => $self->is_dirty, $inline)
    ) if $self->is_dirty;
    $class->add_method(
        $self->_process_accessors('original_value' => $self->original_value, $inline)
    ) if $self->original_value;

    return;
};

before remove_accessors => sub {
    my $self = shift @_;

    # stolen from Class::MOP::Attribute
    my $_remove_accessor = sub {
        my ($accessor, $class) = @_;
        if (ref($accessor) && ref($accessor) eq 'HASH') {
            ($accessor) = keys %{$accessor};
        }
        my $method = $class->get_method($accessor);
        $class->remove_method($accessor)
            if (ref($method) && $method->isa('Class::MOP::Method::Accessor'));
    };

    $_remove_accessor->($self->is_dirty,       $self->associated_class) if $self->is_dirty;
    $_remove_accessor->($self->original_value, $self->associated_class) if $self->original_value;

    return;
};


!!42;



=pod

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Attribute - Track dirtied attributes

=head1 VERSION

version 0.90

=head1 SYNOPSIS

    use Moose;
    use MooseX::TrackDirty::Attributes;

    # one_is_dirty() is generated w/lazy_build
    has one => (is => 'rw', lazy_build => 1);

    # dirtyness "accessor" is generated as two_isnt_clean()
    has two => (is => 'rw', default => 'foo', dirty => 'two_isnt_clean');

    # we do not track three's cleanliness
    has three => (is => 'rw', default => 'foo', track_dirty => 0);

    # ...etc

=head1 DESCRIPTION

MooseX::TrackDirty::Attributes does the necessary metaclass fiddling to track
if attributes are dirty; that is, if they're set to some value not from a
builder, default, or construction.  An attribute can be returned to a clean
state by invoking its clearer.

=head1 WARNING!

This module should be considered alpha at the moment.  I'm still trying to
figure out the best way to do this -- in particular, tracking attribute status
with a hardcoded base class role feels, well, dirty...  It seems like I should
be able to use L<MooseX::Role::Parameterized> to make this a touch more
flexible.

I'll try to preserve this modules behaviour, but no promises at the moment.

=head1 CAVEAT

Note that this is fairly crude; with few exceptions we can only track
dirtiness at the very first level.  That is, if you have an attribute that is
a HashRef, we can tell that the _attribute_ is dirty iff the actual HashRef
ref changes, but not if the HashRef's keys/values change. e.g.
$self->hashref({ new => 'hash' }) would render the 'hashref' attribute dirty,
but $self->hashref->{foo} = 'bar' would not.

=head2 CAVEAT TO THE CAVEAT

Some attributes are designed to be used at this level; namely those that
employ an attribute helper trait to interface with the lower-level bits
directly.  Support for tracking dirtiness at that level is in the works;
right now Array and Hash trait helpers are tracked.

=head1 ATTRIBUTE OPTIONS

We install an attribute metaclass trait that provides three additional
atttribute options, as well as wraps the generated clearer and writer/accessor
methods of the attribute.  By default, use'ing this module causes this
trait to be installed for all attributes defined in the package.

=over 4

=item track_dirty => (0|1)

If true (the default), we track this attrbutes dirtiness and wrap any
generated clearer, setter or accessor methods.

=item dirty => Str

If set, create a "dirtiness accessor".  Default is to not create one.  If
lazy_build is specified, a method is generated with "foo_is_dirty", where foo
is the attribute name.

=item track_attribute_helpers_dirty => (0|1)

If true (the default), we also track any "writing" attribute helper methods
installed by the native attribute traits.  (e.g. Hash, Array, etc.)

Note that this goes deeper than general "dirtiness" tracking.  w/o tracking
attribute helpers, we only mark an attribute as dirty when a setter or
accessor (used as a setter) is invoked.

=back

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut


__END__

