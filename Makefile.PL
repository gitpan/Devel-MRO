use strict;
use warnings;
use inc::Module::Install;
use ExtUtils::Depends;

name 'Devel-MRO';
all_from 'lib/Devel/MRO.pm';

requires 'MRO::Compat' if $] < 5.010_000;
build_requires 'ExtUtils::Depends';

build_requires 'Test::More' => 0.62;

my $pkg = ExtUtils::Depends->new('Devel::MRO');

$pkg->add_pm('lib/Devel/MRO.pm' => '$(INST_LIB)/Devel/MRO.pm');
$pkg->install('mro_compat.h');

mkdir 'xsdepends';
$pkg->save_config('xsdepends/Files.pm');

tests 't/*.t';
author_tests 'xt';

no_index directory => 'example';

WriteMakefile(
	$pkg->get_makefile_vars,
	#FUNCLIST => [qw(mro_get_linear_isa)],

	clean  => {FILES => q(
		Devel-MRO-* *.stackdump
		*.gcda *.gcno *.gcov
		cover_db
		xsdepends
	)},
);
