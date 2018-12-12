use strict;
use warnings;

# run:
# perl solution.pl 4842
# arg = serial number
# can also give second arg for minimum square check size (def. 1)
# third arg is maximum square check size (def. 300)
# fourth arg for debug printing (1 = on)
# fifth arg for checking an individual point (1 = on)
# sixth, sixth for that point's x, y

# problem 1: perl solution.pl 4842 1 3
# problem 2: perl solution.pl 4842
my ($serno, $min_sq_size, $max_sq_size, $d, $c, $px, $py) = @ARGV;

print("Running using serial number $serno...\n");

# probably would have been faster to precompute the 2d array?
# then just go in and sum everything up
# well that's not what i did

# debug print
sub dprint
{
    my ($str) = @_;
    if($d)
    {
        print("$str\n");
    }
}

# get power level of single coord
sub get_level
{
    my ($x, $y) = @_;
    dprint("x, y: ($x, $y)");
    
    my $power = 0;
    
    # get rack id (x + 10)
    my $rack_id = $x + 10;
    dprint("Rack ID: $rack_id");
    
    # power level = rack id * y
    $power = $rack_id * $y;
    dprint("power: $power");
    
    # increase by serno
    $power += $serno;
    dprint("power: $power");
    
    # multiply power level by rack id
    $power *= $rack_id;
    dprint("power: $power");
    
    # keep only hundreds digit (or 0 if none)
    my $num_dig = length $power;
    if($num_dig >= 3)
    {
        $power = substr($power, $num_dig - 3, 1);
        dprint("100's power: $power");
    }
    else
    {
        $power = 0;
        dprint("0's power: $power");
    }
    
    # subtract 5
    $power -= 5;
    
    dprint("power: $power");
    return $power;
}

# get power level of $size by $size grid
sub get_sum_level
{
    my ($start_x, $start_y, $size) = @_;
    my $sum = 0;

    for(my $i = 0; $i < $size; $i += 1)
    {
        for(my $j = 0; $j < $size; $j += 1)
        {
            $sum += get_level($start_x + $i, $start_y + $j);
        }
    }

    return $sum;
}

# scan 300x300 (remember: stay $sq away from right, bottom)
my %max;
$max{'p'} = 0;
$max{'x'} = 0;
$max{'y'} = 0;
$max{'s'} = 0;

# if not checking individual point, check all
if(not $c)
{
    # get min/max square size (default 300)
    my $min_sq = $min_sq_size;
    my $max_sq = $max_sq_size;
    if((not defined $min_sq) or ($min_sq < 1))
    {
        $min_sq = 1;
    }
    if((not defined $max_sq) or ($max_sq < 1))
    {
        $max_sq = 300;
    }

    #iterate all square sizes
    for(my $sq = $min_sq; $sq <= $max_sq; $sq += 1)
    {
        for(my $x = 0; $x < 300 - ($sq - 1); $x += 1)
        {
            for(my $y = 0; $y < 300 - ($sq - 1); $y += 1)
            {
                # get power level of each $sq by $sq configuration
                my $p = get_sum_level($x, $y, $sq);
                
                # find max
                if($p > $max{'p'})
                {
                    $max{'p'} = $p;
                    $max{'x'} = $x;
                    $max{'y'} = $y;
                    $max{'s'} = $sq;
                }
            }
        }
        
        print("Completed checking square size of $sq.\n");
        print("Current maximum power level of " . $max{'p'} . " found at (" . $max{'x'} . ", " . $max{'y'} . ") (size " . $max{'s'} . ")\n");
    }
}
else
{
    print("Power level for point $px, $py: " . get_level($px, $py) . "\n");
}

# return max's startx, starty
print("Absolute maximum power level of " . $max{'p'} . " found at (" . $max{'x'} . ", " . $max{'y'} . ") (size " . $max{'s'} . ")\n");
