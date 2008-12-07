#!perl -w

use strict;
use Test::More tests => 10;

use Devel::MRO qw(:test);

BEGIN{
	require MRO::Compat if $] < 5.010_000;
}

{
	package A;
	package B;
	our @ISA = qw(A);
	package C;
	our @ISA = qw(A);
	package D;
	our @ISA = qw(B C);

	package E;
	use mro 'c3';
	our @ISA = qw(B C);
}

foreach my $class (qw(A B C D E)){
	is_deeply mro_get_linear_isa($class), mro::get_linear_isa($class), "mro_get_linear_isa($class)";
	like mro_get_pkg_gen($class), qr/\A \d+ \z/xms;

	mro_method_changed_in($class); # How to test this behavior?
}
