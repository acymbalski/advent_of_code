use strict;
use warnings;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my $list = <$fh>;
my $polymer = $list;

# trim whitespace
$polymer =~ s/^\s+|\s+$//g;

# we're using poly_length because i'm not entirely sure
# i trust it to re-calculate the length of $polymer every
# iteration if it's in the for loop declaration
my $poly_length = length $polymer;

# using #poly_length - 1 ensures we can always look ahead one char
for (my $i = 0; $i < $poly_length - 1; $i += 1)
{
    # just in case, don't go negative
    if ($i < 0)
    {
        $i = 0;
    }
    
    # get the current character and the one after it
    my $char1 = substr($polymer, $i, 1);
    my $char2 = substr($polymer, $i + 1, 1);
    
    # if the characters don't match, but they do if we force
    # them both to be upper case, their case must differ
    if ((not $char1 eq $char2) and (uc($char1) eq uc($char2)))
    {
        # remove those two characters
        $polymer = substr($polymer, 0, $i) . substr($polymer, $i + 2, (length $polymer) - $i + 1);
        
        # move our index back two so we can check if we
        # just made two reactive poly's adjacent
        $i -= 2;
    }
    
    # update
    $poly_length = length $polymer;
}

# solution 1
print "Resulting length of remaining polymer: " . (length $polymer) . "\n";
