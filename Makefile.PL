use strict;
use warnings;
use inc::Module::Install;

name 'Devel-MRO';
all_from 'lib/Devel/MRO.pm';

requires 'MRO::Compat' if $] < 5.010_000;

build_requires 'Test::More' => 0.62;

tests 't/*.t';
author_tests 'xt';

WriteMakefile(
	clean  => {FILES => q(
		Devel-MRO-* *.stackdump
		*.gcda *.gcno *.gcov
		cover_db
		mro_compat.h
	)},
);
