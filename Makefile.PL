use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'         => 'Embedix::ECD',
    'VERSION_FROM' => 'ECD.pm', # finds $VERSION
    'EXE_FILES'    => [ qw(bin/checkecd bin/ecd2xml) ],
    'PREREQ_PM'    => {
        'Parse::RecDescent' => 0,
        'Data::Dumper'      => 0,
        'Tie::IxHash'       => 0,
        'Pod::Usage'        => 0,
    },
);
