#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Role;
{
  $MooseX::TrackDirty::Attributes::Trait::Role::VERSION = '2.000';
}
# Dist::Zilla: +PkgVersion

use Moose::Role;
use namespace::autoclean;

use MooseX::TrackDirty::Attributes::Util ':all';

# debugging...
#use Smart::Comments;

# ensure that future applications of a native trait will be handled correctly
after add_role => sub {
    my ($self, $other) = @_;

    ### checking: $self->name
    return unless $self->does_role('Moose::Meta::Attribute::Native::Trait');

    ### applying to self...
    TrackDirtyNativeTrait->meta->apply($self);
    return;
};

around composition_class_roles => sub {
    my ($orig, $self) = (shift, shift);

    ### in our composition_class_roles()...
    return ($self->$orig(@_), Composite);
};

!!42;



=pod

=encoding utf-8

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Role

=head1 VERSION

This document describes 2.000 of MooseX::TrackDirty::Attributes::Trait::Role - released February 28, 2012 as part of MooseX-TrackDirty-Attributes.

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
