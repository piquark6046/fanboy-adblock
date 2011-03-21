#
# Fanboy Adblock Sorter v1.4 (21/03/2011)  
# License: http://creativecommons.org/licenses/by/3.0/
# Usage: perl sort.pl <filename.txt>
#
use strict;
use warnings;
use File::Copy;

sub output {
    my( $lines, $fh ) = @_;
    return unless @$lines;
    print $fh shift @$lines; # print first line
    print $fh sort { lc $a cmp lc $b } @$lines;  # print rest
    return;
}
# ======== Main ========
#
my $filename = shift or die 'filename!';
my $outfn = "$filename.out";
# die "output file $outfn already exists, aborting\n" if -e $outfn;
# prereqs okay, set up input, output and sort buffer
#
open my $fh, '<', $filename or die "open $filename: $!";
open my $fhout, '>', $outfn or die "open $outfn: $!";
# Mark filenames for moving (overwriting..)
#
my $filetobecopied = $outfn;
my $newfile = $filename;
# Keep in Binary thus keep in Unix formatted text.
#
binmode($fhout);
my $current = [];
# Process data
# Check "!", "[]" and "#" (Firefox and Opera)
#
while ( <$fh> ) {
    if ( m/^[!#\[]/ ) {
        output $current, $fhout;
        $current = [ $_ ];
    }
    else {
        push @$current, $_;
    }
}
# Finish Up.
#
output $current, $fhout;
close $fhout;
close $fh;
# Move backup file.out (sorted) overwrite orginal (non sorted)
#
move($filetobecopied, $newfile);