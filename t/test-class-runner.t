#!/usr/bin/env perl
use warnings;
use strict;
use Test::Class::Load qw( t/lib );
Test::Class->runtests;

__END__

=pod

  clear ; prove -l lib t/test-class-runner.t -v

=cut
