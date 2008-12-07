package Devel::MRO;

use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use Exporter qw(import);
use File::Basename qw(dirname basename);
use File::Spec;

our @EXPORT      = qw(WriteMRO);
our @EXPORT_FAIL = qw(mro_get_linear_isa mro_get_pkg_gen mro_method_changed_in);

our @EXPORT_OK   = (@EXPORT, @EXPORT_FAIL);

our %EXPORT_TAGS = (test => \@EXPORT_FAIL);

sub export_fail{
	require XSLoader;
	XSLoader::load(__PACKAGE__, $VERSION);
	return ();
}

my $NAME = 'mro_compat';

sub WriteMRO{
	my($name) = @_;
	$name ||= $NAME;

	my $dir = dirname(__FILE__);

	my $h = File::Spec->join($dir, 'MRO', $NAME . '.h');

	my $h_to = $name . '.h';

	_copy($h => $h_to);
}

sub _signeture{
	my($name) = @_;

	my $perlver = sprintf '%vd', $^V;
	my $signeture = <<"END";
----------------------------------------------------------------------------

    $name - Provides mro functions for XS

    Automatically created by Devel::MRO/$VERSION, running under perl $perlver

    Copyright (c) 2008, Goro Fuji <gfuji(at)cpan.org>.

    This program is free software; you can redistribute it and/or
    modify it under the same terms as Perl itself.

----------------------------------------------------------------------------

Usage:
	#include "$name"

Functions:
	AV*  mro_get_linear_isa(HV* stash)
	UV   mro_get_pkg_gen(HV* stash)
	void mro_method_changed_in(HV* stash)


    See "perldoc mro" for details.

END
}

sub _copy{
	my($from, $to) = @_;

	print STDERR "creating $to ... ";

	open my $in, '<', $from or die "Cannot open $from for reading: $!";
	open my $out, '>', $to  or die "Cannot open $to for writing: $!";

	while(<$in>){
		s/ % SIGNETURE % /_signeture(basename($from)) /xmse;
		print $out $_;
	}

	close $in  or die "Cannot close $from opened for reading: $!";
	close $out or die "Cannot close $to opened for writing: $!";

	print STDERR "OK\n";
}
1;
__END__

=head1 NAME

Devel::MRO - Provides mro functions for XS, creating mro_compat.h

=head1 VERSION

This document descrives Devel::MRO version 0.01.

=head1 SYNOPSIS

	# In your XS distribution
	# This makes mro_compat.h in the current directory
	$ perl -MDevel::MRO -e WriteMRO

	# And add the following to your Makefile.PL
	use inc::Module::Install;
	# ...
	requires 'MRO::Compat' if $] < 5.010_000;

	/* Then put the "include" directive in your Module.xs */

	/* ... */
	#include "ppport.h"
	#define NEED_mro_get_linear_isa
	#include "mro_compat.h"

	/* Now you can use several mro functions in your Module.xs:
		mro_get_linear_isa()
		mro_get_pkg_gen()
		mro_method_changed_in()
	*/

=head1 DESCRIPTION

C<Devel::MRO> provides several mro functions for XS.

=head1 Creating source files

=head2 WriteMRO([name])

=head1 XS interface

=head2 AV* mro_get_linear_isa(HV* stash)

=head2 U32 mro_get_pkg_gen(HV* stash)

=head2 void mro_method_changed_in(HV* stash)

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

No bugs have been reported.

Please report any bugs or feature requests to the author.

=head1 AUTHOR

Goro Fuji(gfx) E<lt>gfuji(at)cpan.orgE<gt>.

=head1 SEE ALSO

L<mro>.

L<MRO::Compat>.

L<Devel::PPPort>.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2008, Goro Fuji E<lt>gfuji(at)cpan.orgE<gt>
. Some rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
