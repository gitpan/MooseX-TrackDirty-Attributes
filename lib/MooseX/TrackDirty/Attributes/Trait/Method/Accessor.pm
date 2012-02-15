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
  $MooseX::TrackDirty::Attributes::Trait::Method::Accessor::VERSION = '1.900'; # TRIAL
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

=encoding utf-8

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Method::Accessor - Track dirtied attributes

=head1 VERSION

This document describes 1.900 of MooseX::TrackDirty::Attributes::Trait::Method::Accessor - released February 15, 2012 as part of MooseX-TrackDirty-Attributes.

=head1 DESCRIPTION

This is a trait for accessor methods.  You really don't need to do anything
with it; you want L<MooseX::TrackDirty::Attributes>.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<MooseX::TrackDirty::Attributes|MooseX::TrackDirty::Attributes>

=item *

L<MooseX::TrackDirty::Attributes>

=back

=head1 SOURCE

The development version is on github at L<http://github.com/RsrchBoy/moosex-trackdirty-attributes>
and may be cloned from L<git://github.com/RsrchBoy/moosex-trackdirty-attributes.git>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/RsrchBoy/moosex-trackdirty-attributes/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut


__END__

