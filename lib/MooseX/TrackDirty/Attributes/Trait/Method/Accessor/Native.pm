#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Trait::Method::Accessor::Native;
{
  $MooseX::TrackDirty::Attributes::Trait::Method::Accessor::Native::VERSION = '2.002';
}

# ABSTRACT: Shim trait for handling native trait's writer accessor classes

use Moose::Role;
use namespace::autoclean;

# debugging...
#use Smart::Comments;

Moose::Exporter->setup_import_methods(
    trait_aliases => [
        [ __PACKAGE__, 'AccessorNativeTrait' ],
    ],
);

requires '_inline_optimized_set_new_value';

around _inline_optimized_set_new_value => sub {
    my ($orig, $self) = (shift, shift);
    my ($inv, $new, $slot_access) = @_;

    my $original = $self->$orig(@_);

    ### @_
    ### $original

    my $code = $self
        ->associated_attribute
        ->_inline_set_dirty_slot_if_dirty(@_)
        ;

    $code = "do { $code; $original };";

    ### $code
    return $code;
};

!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Gianni Ceccarelli attribute's

=head1 NAME

MooseX::TrackDirty::Attributes::Trait::Method::Accessor::Native - Shim trait for handling native trait's writer accessor classes

=head1 VERSION

This document describes version 2.002 of MooseX::TrackDirty::Attributes::Trait::Method::Accessor::Native - released November 24, 2012 as part of MooseX-TrackDirty-Attributes.

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
