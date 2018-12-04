use strict;
use warnings;

# solution to parts 1 and 2

# "quick" note:
# you would think that you would, like the Python solution,
# make a list of the sums and just check to see if a sum
# already exists in it. in Perl, no such easy check seems
# to exist; you must iterate the list each time and check.
# this makes the program run so unbelievably slow that it
# would take many minutes to solve; potentially on the
# order of an hour or more.
# however, you could just store the sums in the keys
# of a hash and then check if the key exists (the hash's
# values are useless here). using this method makes this
# program extremely fast; almost "instant"
# anyways that's why there's a hash here instead of a list

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;

# init sum
my $sum = 0;

# init hash of sum values
my %sum_vals;

# keep track of number of cycles
# not needed, but we can print the sum after the first loop this way
my $num_cycles = 0;

# can't break out of two loops; use this
my $keep_cycling = 1;

while ($keep_cycling)
{
    foreach my $itm (@list)
    {
        # add to sum
        $sum += $itm;
        
        # if value has already been seen, we have solved problem 2
        if (exists $sum_vals{$sum})
        {
            # break & terminate next loop
            $keep_cycling = 0;
            last;
        }
        else
        {
            # value is unique; add to hash
            $sum_vals{$sum} = undef;
        }
    }
    
    # only print sum of first cycle
    if ($num_cycles == 0)
    {
        # solution to problem #1
        print "Sum total: " . $sum . "\n";
    }
    $num_cycles += 1;
}

# solution to problem 2
print "Repeated value found: " . $sum . "\n";
