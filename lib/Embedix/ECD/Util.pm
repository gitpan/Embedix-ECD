package Embedix::ECD::Util;

use Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(indent %default @attribute_order);

#_______________________________________
sub indent {
    my $n  = shift() - 1;
    my $sw = shift;
    if ($n  < 0) { $n  = 0 }
    if ($sw < 0) { $sw = 0 }
    return " " x ($n * $sw);
}

# misc configuration
#_______________________________________
%Embedix::ECD::Util::default = (
    shiftwidth => 2,
    indent     => 0,
);

# write attributes in this order
#_______________________________________
@Embedix::ECD::Util::attribute_order = qw(
    help
    prompt

    specpatch
    srpm
    build_vars

    type
    default_value
    value
    range
    choicelist
    if

    static_size
    min_dynamic_size
    storage_size
    startup_time

    provides
    requires
    requiresexpr
    keeplist
    trideps
);

1;
