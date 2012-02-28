#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Attribute::Native::Trait;
{
  $MooseX::TrackDirty::Attributes::Trait::Attribute::Native::Trait::VERSION = '2.000';
}

# ABSTRACT: Compatibility trait between the track-dirty and native traits

use Moose::Role;
use namespace::autoclean;
use MooseX::TrackDirty::Attributes::Util ':all';

use Class::Load 'load_class';

# debugging...
#use Smart::Comments;

# We wrap _native_accessor_class_for() to catch the generated accessor
# classes; if they use the native Writer trait, then we apply our shim trait
# to ensure that dirtyness is properly tracked.

requires '_native_accessor_class_for';

around _native_accessor_class_for => sub {
    my ($orig, $self) = (shift, shift);
    my ($suffix) = @_;

    my $class = $self->$orig(@_);

    return $class unless $class
        ->meta
        ->does_role('Moose::Meta::Method::Accessor::Native::Writer')
        ;

    my $new_class = Moose::Meta::Class->create_anon_class(
        superclasses => [ $class              ],
        roles        => [ AccessorNativeTrait ],
        cache        => 1,
    );

    return $new_class->name;
};

!!42;


=pod

=encoding utf-8

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Attribute::Native::Trait - Compatibility trait between the track-dirty and native traits

=head1 VERSION

This document describes 2.000 of MooseX::TrackDirty::Attributes::Trait::Attribute::Native::Trait - released February 28, 2012 as part of MooseX-TrackDirty-Attributes.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<MooseX::TrackDirty::Attributes|MooseX::TrackDirty::Attributes>

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
