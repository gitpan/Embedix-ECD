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

__END__

=head1 NAME

Embedix::ECD::Util - miscellaneous stuff

=head1 SYNOPSIS

import interesting stuff into your namespace

    use Embedix::ECD::Util qw(indent %default @attribute_order)

=head1 DESCRIPTION

In this module are things that didn't quite fit anywhere else.
I hope to keep the contents of this module to a minimum.

=head1 COPYRIGHT

Copyright (c) 2000 John BEPPU.  All rights reserved.  This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=head1 AUTHOR

John BEPPU <beppu@lineo.com>

=cut
