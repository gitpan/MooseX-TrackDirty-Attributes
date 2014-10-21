#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Method::Accessor;
{
  $MooseX::TrackDirty::Attributes::Trait::Method::Accessor::VERSION = '1.000';
}

# ABSTRACT: Track dirtied attributes

use Moose::Role;
use namespace::autoclean;

# debugging
#use Smart::Comments '###', '####';

sub _generate_original_value_method {
    my $self = shift;
    my $attr = $self->associated_attribute;

    return sub {
        confess "Cannot assign a value to a read-only accessor"
            if @_ > 1;
        $attr->is_dirty_get($_[0]);
    };
}

sub _generate_original_value_method_inline {
    my $self = shift;
    my $attr = $self->associated_attribute;

    return try {
        $self->_compile_code([
            'sub {',
                'if (@_ > 1) {',
                    # XXX: this is a hack, but our error stuff is terrible
                    $self->_inline_throw_error(
                        '"Cannot assign a value to a read-only accessor"',
                        'data => \@_'
                    ) . ';',
                '}',
                $attr->_inline_is_dirty_get('$_[0]'),
            '}',
        ]);
    }
    catch {
        confess "Could not generate inline original_value because : $_";
    };
}


sub _generate_is_dirty_method {
    my $self = shift;
    my $attr = $self->associated_attribute;

    return sub {
        confess "Cannot assign a value to a read-only accessor"
            if @_ > 1;
        $attr->is_dirty_instance($_[0]);
    };
}

sub _generate_is_dirty_method_inline {
    my $self = shift;
    my $attr = $self->associated_attribute;

    return try {
        $self->_compile_code([
            'sub {',
                'if (@_ > 1) {',
                    # XXX: this is a hack, but our error stuff is terrible
                    $self->_inline_throw_error(
                        '"Cannot assign a value to a read-only accessor"',
                        'data => \@_'
                    ) . ';',
                '}',
                $attr->_inline_is_dirty_instance('$_[0]'),
            '}',
        ]);
    }
    catch {
        confess "Could not generate inline is_dirty because : $_";
    };
}

!!42;



=pod

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Method::Accessor - Track dirtied attributes

=head1 VERSION

version 1.000

=head1 DESCRIPTION

This is a trait for accessor methods.  You really don't need to do anything
with it; you want L<MooseX::TrackDirty::Attributes>.

=head1 SEE ALSO

L<MooseX::TrackDirty::Attributes>

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut


__END__

