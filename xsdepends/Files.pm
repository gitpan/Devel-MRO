package Devel::MRO::Install::Files;

$self = {
          'inc' => '',
          'typemaps' => [],
          'deps' => [],
          'libs' => ''
        };


# this is for backwards compatiblity
@deps = @{ $self->{deps} };
@typemaps = @{ $self->{typemaps} };
$libs = $self->{libs};
$inc = $self->{inc};

	$CORE = undef;
	foreach (@INC) {
		if ( -f $_ . "/Devel/MRO/Install/Files.pm") {
			$CORE = $_ . "/Devel/MRO/Install/";
			last;
		}
	}

1;
