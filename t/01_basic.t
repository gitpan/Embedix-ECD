use strict;
use Embedix::ECD;

print "1..3\n";
my $test = 1;

# dealing with an undefined object
my $ecd  = Embedix::ECD->new();
my $kaka = $ecd->kaka();
print "not " if (defined $kaka);
print "ok $test\n";
$test++;

# building an object hierarchy
my $gr1 = Embedix::ECD::Group->new(name => 'system');
my $gr2 = Embedix::ECD::Group->new(name => 'utilities');
$ecd->addChild($gr1);
$ecd->system->addChild($gr2);
my $obj = $ecd->system->utilities;
print "not " if ($gr2->{name} ne $obj->{name});
print "ok $test\n";
$test++;

# instantiating an object w/ attribute values
my $busybox = Embedix::ECD::Component->new (
    name => 'busybox',
    srpm => 'busybox',
    help => 'swiss army knife or something',
);
print "not " if ($busybox->srpm ne 'busybox');
print "ok $test\n";
$test++;

# vim:syntax=perl
