use strict;
use warnings;

# yeesh
# this program DOES work! it's just... very ugly
# do i like perl? at the moment, no, thank you
# i shudder to think of how much more efficient
# this could be

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;

# smaller numbers make the calculations faster
# it should be equivalent to the largest x and y
# in the given input coords
# yeah you could calculate this, i just didn't
my $max_w = 500;
my $max_h = 500;

# for problem 2, given search dist
my $search_dist = 10000;

# initialize 2d array of hashes
print "initializing grid...\n";
my @grid = ();
for (my $i = 0; $i < $max_w; $i += 1)
{
    @grid[$i] = ();
    
    for (my $j = 0; $j < $max_h; $j += 1)
    {
        # create hash
        $grid[$i][$j] = {};
        
        # create list to keep track of all
        # closest source coordinates
        $grid[$i][$j]{"closest"} = ();
      
        # manhattan distance to the nearest
        # source coordinate(s)
        $grid[$i][$j]{"dist"} = $max_w + $max_h + 1;
        
        # used for problem 2
        # sum distance to all source coordinates
        $grid[$i][$j]{"dist_to_all"} = 0;
        
        
    }
}

# print 2d grid
# this isn't used as our 2d array is a little
# complex, but this could be useful later
# usage: print_grid(@grid)
sub print_grid
{
    my (@array) = @_;
    
    for (my $i = 0; $i < $max_w; $i += 1)
    {
        for (my $j = 0; $j < $max_h; $j += 1)
        {
            print $array[$i][$j] . " ";
            
        }
        print "\n";
    }
}

# get manhattan distance from one point to another
# usage: get_distance(startx, starty, endx, endy)
# returns distance
sub get_distance
{
    my ($startx, $starty, $endx, $endy) = @_;
    
    my $dist = 0;
    
    $dist = (abs ($endx - $startx)) + (abs ($endy - $starty));
    
    return $dist;
}

# calculate distances to each source coordinate
# from every point on the grid
print "calculating distances...\n";
for (my $i = 0; $i < $max_w; $i += 1)
{
    for (my $j = 0; $j < $max_h; $j += 1)
    {
        # ref to closest distance
        my $closest_dist = $grid[$i][$j]{"dist"};
    
        # iterate input list
        foreach my $itm (@list)
        {
            # location to split x,y coords on in source line
            my $split_loc = index($itm, ",");
            
            # get x,y coords
            my $x = substr($itm, 0, $split_loc);
            my $y = substr($itm, $split_loc + 2, (length $itm) - $split_loc);
            
            # calculate distance from grid location to sourc point
            my $distance = get_distance($i, $j, $x, $y);
            
            # add to sum of all distances for this point
            # used for part 2
            $grid[$i][$j]{"dist_to_all"} += $distance;
            
            # if this point is equidistant to more than one point,
            # add this source point to the array of closest points
            if ($distance == $closest_dist)
            {
                push @{ $grid[$i][$j]{"closest"} }, $itm;
            }
            
            # otherwise, if it's the new closest, recreate the
            # array with just this point
            if ($distance < $closest_dist)
            {
                @{$grid[$i][$j]{"closest"}} = ($itm);
                
                # and keep track of the new closest distance
                $grid[$i][$j]{"dist"} = $distance;
                $closest_dist = $distance;
            }
        }
    }
}

print "building ignore list...\n";
# get list of "inifinite" coord boundaries
# which is really just everything touching an edge
# we will ignore things on this hash later
# why a hash? see day 1's solution.pl's "quick note"
my %ignore_list;
for (my $i = 0; $i < $max_w; $i += 1)
{
    for (my $j = 0; $j < $max_h; $j += 1)
    {
        # is this point on an edge?
        if ($i == 0 or $i == $max_w - 1 or $j == 0 or $j == $max_h - 1)
        {
            # if this point belongs to only one source point,
            # add the source point to the list to be ignored later
            # "size of blob is infinite"
            if (length scalar(@{$grid[$i][$j]{"closest"}}) == 1)
            {
                # again, hash magic
                # we don't care about the value, just the key
                # lets us use "exists" later for faster searching
                $ignore_list{$grid[$i][$j]{"closest"}[0]} = undef;
            }
        }
    }
}

# count the size of each blob
print "counting blob sizes...\n";
# create hash to keep track
my %blobs;

# iterate source coords yet again
foreach my $itm (@list)
{
    # blob size init
    my $blob_size = 0;
    
    # iterate grid
    for (my $i = 0; $i < $max_w; $i += 1)
    {
        for (my $j = 0; $j < $max_h; $j += 1)
        {
            # if the length of the closest source coords
            # to this point is exactly 1 (i.e. this point
            # belongs to exactly one blob, it is not contested)...
            if ((scalar(@{$grid[$i][$j]{"closest"}})) == 1)
            {
                my $key = $grid[$i][$j]{"closest"}[0];
                
                # if the blob is not "infinite" and the blob belongs
                # to this given coordinate (from the file), increment
                # blob size
                if (not exists $ignore_list{$key} and $key eq $itm)
                {
                    $blob_size += 1;
                }
            }
        }
    }
    
    # save blob size for this input coord
    $blobs{$itm} = $blob_size;
}

# find largest blob
print "finding largest blob...\n";
my $largest_v = 0;
while(my($k, $v) = each %blobs) 
{
    if ($v > $largest_v)
    {
        $largest_v = $v;
    }
}

# solution 1
print "\nLargest value: $largest_v\n";

# problem 2
# find number of tiles within $search_dist to
# the sum of all given coords
my $num_within_range = 0;
for (my $i = 0; $i < $max_w; $i += 1)
{
    for (my $j = 0; $j < $max_h; $j += 1)
    {
        if ($grid[$i][$j]{"dist_to_all"} < $search_dist)
        {
            $num_within_range += 1;
        }
    }
}

# solution 2
print "Number of tiles within range $search_dist: $num_within_range\n";
