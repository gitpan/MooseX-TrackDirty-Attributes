#
# This file is part of MooseX-TrackDirty-Attributes
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::TrackDirty::Attributes::Util;
{
  $MooseX::TrackDirty::Attributes::Util::VERSION = '2.000';
}

# ABSTRACT: Laziness -- alias functions

use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [ qw{
        trait_for application
        Composite ToRole ToClass ToInstance
        AccessorNativeTrait TrackDirtyNativeTrait
    } ],
    groups => { default => ':all' },
};

sub trait_for($)            { "MooseX::TrackDirty::Attributes::Trait::$_[0]" }
sub application($)          { trait_for "Role::Application::$_[0]"           }
sub Composite()             { trait_for 'Role::Composite'                    }
sub ToInstance()            { application 'ToInstance'                       }
sub ToClass()               { application 'ToClass'                          }
sub ToRole()                { application 'ToRole'                           }
sub TrackDirtyNativeTrait() { trait_for 'Attribute::Native::Trait'           }
sub AccessorNativeTrait()   { trait_for 'Method::Accessor::Native'           }

!!42;



=pod

=encoding utf-8

=head1 NAME

MooseX::TrackDirty::Attributes::Util - Laziness -- alias functions

=head1 VERSION

This document describes 2.000 of MooseX::TrackDirty::Attributes::Util - released February 28, 2012 as part of MooseX-TrackDirty-Attributes.

=for Pod::Coverage trait_for application Composite ^To.*$ TrackDirtyNativeTrait AccessorNativeTrait

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

