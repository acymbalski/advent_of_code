use strict;
use warnings;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;

# takes two strings, returns number of differing characters
sub num_diff_chars
{
    my ($str1, $str2) = @_;
    my $diff = 0;
    
    my $min_str_size = length $str1;
    my $size_diff = (length $str1) - (length $str2);
    if ($size_diff < 0)
    {
        $min_str_size = length $str2;
        $size_diff *= -1;
    }
    
    for(my $i = 0; $i < $min_str_size; $i += 1)
    {
        if (substr($str1, $i, 1) ne substr($str2, $i, 1))
        {
            $diff += 1;
        }
    }
    
    $diff += $size_diff;
    
    return $diff;
}

# takes two strings, returns string of the common characters
sub get_common_str
{
    my ($str1, $str2) = @_;
    my $common_str = "";
    
    my $min_str_size = length $str1;
    my $size_diff = (length $str1) - (length $str2);
    if ($size_diff < 0)
    {
        $min_str_size = length $str2;
        $size_diff *= -1;
    }
    
    for(my $i = 0; $i < $min_str_size; $i += 1)
    {
        my $char1 = substr($str1, $i, 1);
        if ($char1 eq substr($str2, $i, 1))
        {
            $common_str = $common_str . $char1;
        }
    }
    
    return $common_str;
}

# number of 2s and 3s
my $contains_2 = 0;
my $contains_3 = 0;

# did we already find our near-matched ids?
my $found_single_diff = 0;
# store common string between our two ids
my $common_str = "";

# iterate list
foreach my $itm (@list)
{
    # does this string contain a character exactly twice/thrice?
    my $does_contain_2 = 0;
    my $does_contain_3 = 0;
    
    # iterate all characters in id
    for(my $i = 0; $i < length $itm; $i += 1)
    {
        # get individual char from index
        my $char = substr($itm, $i, 1);
        # get counts of that char in the id
        my $count = () = $itm =~ /\Q$char/g;
        
        if ($count == 2)
        {
            $does_contain_2 = 1;
        }
        if ($count == 3)
        {
            $does_contain_3 = 1;
        }
    }
    
    if ($does_contain_2)
    {
        $contains_2 += 1;
    }
    if ($does_contain_3)
    {
        $contains_3 += 1;
    }
    
    # solution 2
    # did we already solve problem 2?
    if (not $found_single_diff)
    {
        # iterate the list of ids within this current iteration
        foreach my $subitm (@list)
        {
            # if the two strings differ by 1 character, we found it
            if (num_diff_chars($itm, $subitm) == 1)
            {
                # get common string
                $common_str =  get_common_str($itm, $subitm);
                
                # break out and don't come back
                $found_single_diff = 1;
                last;
            }
        }
    }
}

# solution 1
print "num of twos: $contains_2\n";
print "num of threes: $contains_3\n";
print "checksum: " . $contains_2 * $contains_3 . "\n\n";

# solution 2
print "Common str (diff = 1) found: \n$common_str\n";
