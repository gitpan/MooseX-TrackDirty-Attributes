#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Role::Application::ToInstance;
{
  $MooseX::TrackDirty::Attributes::Trait::Role::Application::ToInstance::VERSION = '2.002';
}

# ABSTRACT: Application to instance helper trait

use Moose::Role;
use namespace::autoclean;
use MooseX::TrackDirty::Attributes::Util ':all';

# debug...
#use Smart::Comments;

after apply => sub {
    my ($self, $role, $object) = @_;

    my $object_meta = Class::MOP::class_of($object);

    ### Application to instance...
    ### role:   $role->name
    ### target: $object_meta->name

    ### applying metaroles to: $object_meta->name
    Moose::Util::MetaRole::apply_metaroles(
        for => $object_meta,
        class_metaroles => {
            class => [ trait_for 'Class' ],
        },
    );

    #my @roles = map { $_->name } $object_meta->calculate_all_roles_with_inheritance;
    ### @roles
    #my @meta_roles = map { $_->name } $object_meta->meta->calculate_all_roles_with_inheritance;
    ### @meta_roles

    $object->remove_accessors;
    Moose::Util::apply_all_roles($object, TrackDirtyNativeTrait)
        if $object_meta->does_role('Moose::Meta::Attribute::Native::Trait');
    $object->install_accessors;

    return;
};

!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Gianni Ceccarelli attribute's

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Role::Application::ToInstance - Application to instance helper trait

=head1 VERSION

This document describes version 2.002 of MooseX::TrackDirty::Attributes::Trait::Role::Application::ToInstance - released November 24, 2012 as part of MooseX-TrackDirty-Attributes.

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
