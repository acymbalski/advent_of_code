use strict;
use warnings;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my $list = <$fh>;
# trim whitespace
$list =~ s/^\s+|\s+$//g;

# alphabet to iterate through (case insensitively)
my @alphabet = ('a'..'z');

# hash to store results
my %results;

# iterate alphabet
foreach my $itm (@alphabet)
{
    # re-create polymer
    my $polymer = $list;
    
    # remove instances of $itm
    # g = "globally" i.e. more than once
    # i = case insensitive
    $polymer =~ s/$itm//gi;

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
    
    # store result for this character
    $results{$itm} = length $polymer;
}

my $min_key = 'a';
# iterate all results, find minimum
while(my($k, $v) = each %results) 
{
    if ($v < $results{$min_key})
    {
        $min_key = $k;
    }
}


# solution 2
print "Removing letter '$min_key' gets the smallest polymer, length $results{$min_key}\n";
