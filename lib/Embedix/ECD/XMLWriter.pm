package Embedix::ECD::XMLWriter;

use strict;
use vars qw(@ISA @EXPORT_OK);

# for its import method
use Exporter;

# this should already be loaded (but just in case)
use Embedix::ECD;

# this should already be loaded (but just in case)
use Embedix::ECD::Util qw(%default);

@ISA       = qw(Exporter);
@EXPORT_OK = qw(xml_from_cons);

# this contains the dtd
$Embedix::ECD::XMLWriter::__dtd = q/<!-- root node -->
<!ELEMENT ecd (group*, component*, option*, autovar*)>

<!-- attributes -->
<!ELEMENT help              (#PCDATA)>
<!ELEMENT prompt            (#PCDATA)>
<!ELEMENT specpatch         (#PCDATA)>
<!ELEMENT srpm              (#PCDATA)>
<!ELEMENT build_vars        (#PCDATA)>
<!ELEMENT type              (#PCDATA)>
<!ELEMENT default_value     (#PCDATA)>
<!ELEMENT value             (#PCDATA)>
<!ELEMENT range             (#PCDATA)>
<!ELEMENT choicelist        (#PCDATA)>
<!ELEMENT if                (#PCDATA)>
<!ELEMENT static_size       (#PCDATA)>
<!ELEMENT min_dynamic_size  (#PCDATA)>
<!ELEMENT storage_size      (#PCDATA)>
<!ELEMENT startup_time      (#PCDATA)>
<!ELEMENT provides          (#PCDATA)>
<!ELEMENT requires          (#PCDATA)>
<!ELEMENT requiresexpr      (#PCDATA)>
<!ELEMENT keeplist          (#PCDATA)>
<!ELEMENT trideps           (#PCDATA)>

<!-- group node -->
<!ELEMENT group
  (
    help?,
    prompt?,
    specpatch?,
    srpm?,
    build_vars?,
    type?,
    default_value?,
    value?,
    range?,
    choicelist?,
    if?,
    static_size?,
    min_dynamic_size?,
    storage_size?,
    startup_time?,
    provides?,
    ( requires | requiresexpr )?,
    keeplist?,
    trideps?,
    group*,
    component*,
    option*,
    autovar*
  )
>
<!ATTLIST group
  name CDATA #REQUIRED
>

<!-- component node -->
<!ELEMENT component
  (
    help?,
    prompt?,
    specpatch?,
    srpm?,
    build_vars?,
    type?,
    default_value?,
    value?,
    range?,
    choicelist?,
    if?,
    static_size?,
    min_dynamic_size?,
    storage_size?,
    startup_time?,
    provides?,
    ( requires | requiresexpr )?,
    keeplist?,
    trideps?,
    group*,
    component*,
    option*,
    autovar*
  )
>
<!ATTLIST component
  name CDATA #REQUIRED
>

<!-- option node -->
<!ELEMENT option
  (
    help?,
    prompt?,
    specpatch?,
    srpm?,
    build_vars?,
    type?,
    default_value?,
    value?,
    range?,
    choicelist?,
    if?,
    static_size?,
    min_dynamic_size?,
    storage_size?,
    startup_time?,
    provides?,
    ( requires | requiresexpr )?,
    keeplist?,
    trideps?,
    group*,
    component*,
    option*,
    autovar*
  )
>
<!ATTLIST option
  name CDATA #REQUIRED
>

<!-- autovar node -->
<!ELEMENT autovar
  (
    help?,
    prompt?,
    specpatch?,
    srpm?,
    build_vars?,
    type?,
    default_value?,
    value?,
    range?,
    choicelist?,
    if?,
    static_size?,
    min_dynamic_size?,
    storage_size?,
    startup_time?,
    provides?,
    ( requires | requiresexpr )?,
    keeplist?,
    trideps?,
    group*,
    component*,
    option*,
    autovar*
  )
>
<!ATTLIST autovar
  name CDATA #REQUIRED
>
/;

# take a nested arrayref instead of an Embedix::ECD object
#_______________________________________
sub xml_from_cons {
    my $cons = shift; (@_ & 1) && die "Odd number of parameters.\n";
    my %opt  = @_;

    my $i  = $opt{indent}     || $default{indent};
    my $sw = $opt{shiftwidth} || $default{shiftwidth};

    my $indent = " " x $i;
    my $shift  = " " x $sw;

    return
        qq($indent<?xml version="1.0"?>\n) .
        "$indent<ecd>\n" .
        xml_from_cons2($cons, $indent . $shift, $shift) .
        "$indent</ecd>\n";
}

#_______________________________________
sub xml_for_attribute {
    my $attr   = shift;
    my $indent = shift;
    my $shift  = shift;

    my $xml;
    if (ref($attr->[1])) {
        $xml =
            "$indent<"  . lc($attr->[0]) . ">\n" .
            join('', map { s/&/&amp;/g; "$indent$shift$_\n" } @{$attr->[1]}) .
            "$indent</" . lc($attr->[0]) . ">\n";
    } else {
        my $k = lc $attr->[0];
        my $v = $attr->[1];
        $v    =~ s/&/&amp;/g;
        $xml  = sprintf("$indent<%s>%s</%s>\n", $k, $v, $k);
    }
    return $xml;
}

#_______________________________________
sub xml_for_comment {
    my $comment = shift;
    my $indent  = shift;
    my $n       = scalar(@{$comment->[1]});

    my $xml;
    if ($n > 1) {
        $xml =
            "$indent<!--\n" .
            join('', map { s/--/&dash;/g; "$indent$_\n" } @{$comment->[1]}) .
            "$indent  -->\n";
    } else {
        my $c = ($n) ? $comment->[1][0] : "";
        $c    =~ s/--/&dash;/g;
        $xml  = qq($indent<!-- $c -->\n);
    }
    return $xml;
}

#_______________________________________
sub xml_from_cons2 {
    my $cons   = shift;
    my $indent = shift;
    my $shift  = shift;

    my $i;
    my $xml = "";
    while ($i = shift(@$cons)) {
        if (ref($i->[0])) {
            # node
            $xml .=
                "$indent<"  . lc($i->[0][0]) . qq( name="$i->[0][1]">\n) .
                xml_from_cons2($i->[1], $indent . $shift, $shift) .
                "$indent</" . lc($i->[0][0]) .">\n";
        } else {
            # attribute
            if ($i->[0] eq "Comment") {
                $xml .= xml_for_comment($i, $indent, $shift);
            } else {
                $xml .= xml_for_attribute($i, $indent, $shift);
            }

        }
    }
    return $xml;
}

{
    package Embedix::ECD;
    # use XML::Parser;

    #_______________________________________
    sub newFromXML {

    }

    #_______________________________________
    sub toXML {
        my $self = shift;
        my $opt  = $self->getFormatOptions(@_);
        my $dtd;
        $opt->{dtd} && do {
            if ($opt->{dtd} eq "yes") {
                $dtd = qq(<!DOCTYPE ecd SYSTEM "ecd_v1.dtd">\n);
            } elsif ($opt->{dtd} eq "embed") {
                $dtd = qq(<!DOCTYPE ecd [\n$Embedix::ECD::XMLWriter::__dtd]>);
            } elsif ($opt->{dtd} eq "no") {
                $dtd = "";
            } else {
                die "dtd => $opt->{dtd} is not a valid option for toXML()\n";
            }
        };
        if ($self->getDepth == 0) {
            return 
                qq(<?xml version="1.0"?>\n) .
                $dtd .
                "<ecd>\n" . 
                join('', map { $_->toXML(@_) } $self->getChildren()) .
                "</ecd>\n";
        } else {
            "$opt->{space}<". lc $self->getNodeType .qq( name=").$self->name.qq(">\n) .
                $self->attributeToXML($opt) .   # for the attributes
                join('', map { $_->toXML(@_) } $self->getChildren()) .
            "$opt->{space}</" . lc $self->getNodeType . ">\n";
        }
    }

    # render the attributes of a node
    # It's rare for me to nest this much.
    #_______________________________________
    sub attributeToXML {
        my $self = shift;
        my $opt  = shift;
        my ($sw, $space, $space2) = map { $opt->{$_} } qw(sw space space2);
        my $a;
        return join '', map {
            $a = $self->getAttribute($_);
            if (defined($a)) {
                if (ref($a)) {
                    if (scalar(@$a)) {
                        # an aggregate attribute
                        $space2 . "<" . lc($_) . ">\n" .
                        join (
                            '', 
                            map { 
                                s/&/&amp;/g; 
                                $space2 . " " x $sw . "$_\n" 
                            } @$a
                        ) .
                        $space2 . "</" . lc($_) . ">\n";
                    } else {
                        # an empty aggregate attribute
                        "";
                    }
                } else {
                    # a scalar attribute
                    $space2 . "<" . lc($_) . ">$a" .  
                    "</" . lc($_) . ">\n";
                }
            }
        } @{$opt->{order}};
    }
}

1;

__END__

=head1 NAME

Embedix::ECD::XMLWriter - adds a method to write ECD data as XML

=head1 SYNOPSIS

Load appropriate modules first

    use Embedix::ECD;
    use Embedix::ECD::XMLWriter qw(xml_from_cons);

load an ECD and print it as XML

    my $ecd->newFromFile('tinylogin.ecd');
    print $ecd->toXML;

If you want to preserve comments, use a cons instead of an Embedix::ECD
object.

    my $cons = Embedix::ECD->consFromFile('tinylogin.ecd');
    print xml_from_cons($cons);

=head1 REQUIRES

=over 4

=item Embedix::ECD

This is the module Embedix::ECD::XMLWriter augments.

=back

=head1 EXPORTS

=over 4

=item xml_from_cons($cons)

=back

=head1 DESCRIPTION

This module adds a few methods to the Embedix::ECD namespace for the
purposes of XML generation.  The reason it has been separated from
the main module is to allow one to only load this module when necessary
and to save memory when you it's not.

=head1 METHODS

=head2 Generating XML from a cons

=over 4

=item $xml = xml_from_cons($cons);

A cons (or nested arrayref) is generated from the constructors in
Embedix::ECD that have names starting with "cons".  This method
will take a cons and generate well-formed XML from it.  Because
a cons preserves comments in an ECD, xml_from_cons() is able to
preserve comments in the XML it generates.

Although the XML this generates will be well-formed, it runs a
high risk of not being valid, because it cannot (yet?) order the
attributes in accordance w/ the current DTD.

=back

=head2 Add-ons to Embedix::ECD

=over 4

=item $ecd = Embedix::ECD->newFromXML()

not implemented.  

=item $xml = $ecd->toXML()

This generates an XML expression of an ECD in accordance to the DTD found
in $Embedix::ECD::XMLWriter::__dtd.  The generated XML will be well-formed
and valid.

=item $string = $ecd->attributeToXML()

This does the same thing as attributeToString() but generates XML, instead.

=back

=head1 CLASS VARIABLES

=over 4

=item $Embedix::ECD::XMLWriter::__dtd

This contains the Document Type Definition for the XML version of the
ECD format.

=back

=head1 AUTHOR

John BEPPU <beppu@lineo.com>

=head1 SEE ALSO

=over 4

=item related perl modules

Embedix::ECD(3pm)

=back

=cut

# $Id: XMLWriter.pm,v 1.5 2000/12/06 22:27:24 beppu Exp $
