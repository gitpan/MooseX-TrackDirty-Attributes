#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Class;
{
  $MooseX::TrackDirty::Attributes::Trait::Class::VERSION = '2.002';
}

# ABSTRACT: Attribute metaclass helper metaclass helper trait

use Moose::Role;
use namespace::autoclean;
use MooseX::TrackDirty::Attributes::Util ':all';

# debug...
#use Smart::Comments;


# ensure that future applications of a native trait will be handled correctly
after add_role_application => sub {
    my ($self, $application) = @_;

    #my @roles = map { $_->name } $self->calculate_all_roles;
    ### @roles

    ### in add_role_application (after)...
    return unless $self->does_role('Moose::Meta::Attribute::Native::Trait');
    return if $self->does_role(TrackDirtyNativeTrait);

    ### applying TrackDirtyNativeTrait to self: $self->name
    TrackDirtyNativeTrait->meta->apply($self);
    return;
};

!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Gianni Ceccarelli attribute's

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Class - Attribute metaclass helper metaclass helper trait

=head1 VERSION

This document describes version 2.002 of MooseX::TrackDirty::Attributes::Trait::Class - released November 24, 2012 as part of MooseX-TrackDirty-Attributes.

=head1 METHODS

=head2 add_role_application

This method is extended to ensure that if our attribute metaclass starts doing
a native trait, that our native trait compatibility trait is also applied.

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

=head1 CONTRIBUTOR

Gianni Ceccarelli <gianni.ceccarelli@net-a-porter.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
