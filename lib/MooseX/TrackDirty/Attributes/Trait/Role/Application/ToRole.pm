#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Role::Application::ToRole;
{
  $MooseX::TrackDirty::Attributes::Trait::Role::Application::ToRole::VERSION = '2.000';
}

# ABSTRACT: Application to role helper trait

use Moose::Role;
use namespace::autoclean;
use Moose::Util::MetaRole;
use MooseX::TrackDirty::Attributes::Util ':all';

# debug...
#use Smart::Comments;


around apply => sub {
    my ($next, $self, $role1, $role2) = @_;

    ### role1 (source): $role1->name
    ### role2 (target): $role2->name

    $self->$next(
        $role1,
        Moose::Util::MetaRole::apply_metaroles(
            for            => $role2,
            role_metaroles => {
                role                    => [ trait_for 'Role' ],
                application_to_class    => [ ToClass          ],
                application_to_role     => [ __PACKAGE__      ],
                application_to_instance => [ ToInstance       ],
            },
        ),
    );

    ### check to see if our target now does the native trait...
    return
        unless $role2->does_role('Moose::Meta::Attribute::Native::Trait');

    ### applying TrackDirtyNativeTrait to: $role2->name
    TrackDirtyNativeTrait->meta->apply($role2);
    return;
};

!!42;

__END__
=pod

=encoding utf-8

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Role::Application::ToRole - Application to role helper trait

=head1 VERSION

This document describes 2.000 of MooseX::TrackDirty::Attributes::Trait::Role::Application::ToRole - released February 28, 2012 as part of MooseX-TrackDirty-Attributes.

=head1 METHODS

=head2 apply

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

