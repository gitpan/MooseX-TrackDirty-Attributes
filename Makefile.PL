
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Track dirtied attributes",
  "AUTHOR" => "Chris Weyl <cweyl\@alumni.drew.edu>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Moose::Util" => 0,
    "Test::Moose" => 0,
    "Test::Moose::More" => "0.009",
    "Test::More" => "0.92"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "MooseX-TrackDirty-Attributes",
  "EXE_FILES" => [],
  "LICENSE" => "lgpl",
  "NAME" => "MooseX::TrackDirty::Attributes",
  "PREREQ_PM" => {
    "Class::Load" => 0,
    "Moose" => "2.0",
    "Moose::Exporter" => 0,
    "Moose::Role" => 0,
    "Moose::Util::MetaRole" => 0,
    "MooseX::AttributeShortcuts" => "0.008",
    "MooseX::Types::Perl" => 0,
    "Sub::Exporter" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "2.002",
  "test" => {
    "TESTS" => "t/*.t t/native-traits/*.t t/native-traits/extends/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



