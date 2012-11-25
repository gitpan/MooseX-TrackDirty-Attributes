#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Role::Composite;
{
  $MooseX::TrackDirty::Attributes::Trait::Role::Composite::VERSION = '2.002';
}

# ABSTRACT: Apply our application::to* traits to any composition of our role and any other

use Moose::Role;
use namespace::autoclean;

use MooseX::TrackDirty::Attributes::Util ':all';

# debugging...
#use Smart::Comments;


around apply_params => sub {
    my ($orig, $self) = (shift, shift);

    return Moose::Util::MetaRole::apply_metaroles(
        for            => $self->$orig(@_),
        role_metaroles => {
            role => [ trait_for 'Role' ],
            application_to_class    => [ ToClass    ],
            application_to_role     => [ ToRole     ],
            application_to_instance => [ ToInstance ],
        },
    );
};


!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Gianni Ceccarelli attribute's

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Role::Composite - Apply our application::to* traits to any composition of our role and any other

=head1 VERSION

This document describes version 2.002 of MooseX::TrackDirty::Attributes::Trait::Role::Composite - released November 24, 2012 as part of MooseX-TrackDirty-Attributes.

=head1 METHODS

=head2 apply_params

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
