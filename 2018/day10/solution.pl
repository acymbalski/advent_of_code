use strict;
use warnings;
# for drawing the final image
use Image::Base::GD;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;


# so the logic behind this one is kind of interesting
# we have a large list of x,y points with an additional x,y velocity
# the values range from over -50k to over +50k, which means
# it's just insanely impractical to draw the stars each second and
# just "check" for a word, especially since we can probably expect
# that we won't see it for a long time
# so the idea is this: pick an arbitrary number of iterations
# (i started with 50k but found it could be reduced to 11k)
# for each iteration, find largest x and y position from all the stars
# (x and y not necessarily from the same star)
# and do the same for the smallest x and y position
# then, compute the distance between these points
# these resulting numbers mean that every star is contained within
# a box this size
# we can also assume that when the stars form the word, they will
# never be closer, since they are moving in -x, +x, -y, and +y
# so if we keep track of the size of this shrink-wrapped box,
# logically, you could expect that when it reaches its absolute minimum
# over the course of all the iterations, the word is found at that point
# in time
# small tweak: i don't think we can exactly guarantee what orientation
# the words will be in, so we're going to track two separate times:
# the minimum x and minimum y distance (in the real problem these happen
# to be at exactly the same time)
# so that's what we do: find this time where everything is packed
# the tightest, get the size of that box, then re-set and re-compute
# until we get to that time again (since we blew past it; i guess you
# could just start computing backwards but i didn't) - once we get to that
# time, draw an image focused on that sub-section of the entire sky
# for some reason my word is completely backwards and upside-down
# but like all my solutions "it technically works"


# iterate 11k times
# kind of arbitrary; it should be "large"
# in our case we have found that it happens between 10k and 11k
my $num_iter = 11000;

sub init_pos
{
    my @init = ();
    # parse data from text file
    foreach my $itm (@list)
    {
        my $rem_str = $itm;

        my $next = index($rem_str, "<");
        my $sep = index($rem_str, ",");
        my $end = index($rem_str, ">");
        
        my $x = substr($rem_str, $next + 1, $sep - $next - 1);
        my $y = substr($rem_str, $sep + 2, $end - $sep - 2);
        
        $rem_str = substr($rem_str, $end + 1, (length $rem_str) - $end);
        
        $next = index($rem_str, "<");
        $sep = index($rem_str, ",");
        $end = index($rem_str, ">");
        
        my $vx = substr($rem_str, $next + 1, $sep - $next - 1);
        my $vy = substr($rem_str, $sep + 2, $end - $sep - 2);
                
        my %star;
        $star{"x"} = $x;
        $star{"y"} = $y;
        $star{"vx"} = $vx;
        $star{"vy"} = $vy;
        
        push @init, \%star;        
    }
    
    return @init;
}


my @stars = init_pos();

my $min_x_iter = 0;
my $min_y_iter = 0;
my $min_x_d = undef;
my $min_y_d = undef;
for(my $i = 1; $i < $num_iter; $i += 1)
{

    # find smallest/largest x/y for this second
    my $min_x = 0;
    my $min_y = 0;
    my $max_x = 0;
    my $max_y = 0;
    
    # move each star by its velocity
    for(my $j = 0; $j < scalar(@stars); $j += 1)
    {
        my $st = $stars[$j];
        my %s = %{$st};
        $s{"x"} += $s{"vx"};
        $s{"y"} += $s{"vy"};
        
        # find the min/max x, min/max y
        if($s{"x"} < $min_x)
        {
            $min_x = $s{"x"};
        }
        if($s{"x"} > $max_x)
        {
            $max_x = $s{"x"};
        }
        
        if($s{"y"} < $min_y)
        {
            $min_x = $s{"y"};
        }
        if($s{"y"} > $max_y)
        {
            $max_y = $s{"y"};
        }
        
        $stars[$j] = \%s;
    
    }
    
    if(not defined $min_x_d or ($max_x - $min_x < $min_x_d))
    {
        $min_x_d = $max_x - $min_x;
        $min_x_iter = $i;
    }
    if(not defined $min_y_d or ($max_y - $min_y < $min_y_d))
    {
        $min_y_d = $max_y - $min_y;
        $min_y_iter = $i;
    }
    
    if($i % 1000 == 0)
    {
        print("iter $i...\n");
    }
    
}

print("On iteration $min_x_iter, the minimum x distance of $min_x_d was reached.\n");
print("On iteration $min_y_iter, the minimum y distance of $min_y_d was reached.\n");

# draw
my $largest = $min_x_d;
if($min_y_d > $largest)
{
    $largest = $min_y_d;
}

print("Resetting and recomputing to find the word...\n");

# reload stars
@stars = init_pos();

# used to check if both minx and miny images have been saved
# so we can quit earlier
my $x_saved = 0;
my $y_saved = 0;
for(my $i = 1; $i <= $num_iter; $i += 1)
{
    # find smallest/largest x/y for this second
    my $min_x = 0;
    my $min_y = 0;
    my $max_x = 0;
    my $max_y = 0;
    
    # move each star by its velocity
    for(my $j = 0; $j < scalar(@stars); $j += 1) #each my $star (@stars)
    {
        my $st = $stars[$j];
        my %s = %{$st};
        $s{"x"} += $s{"vx"};
        $s{"y"} += $s{"vy"};
        
        # find the min/max x, min/max y
        if($s{"x"} < $min_x)
        {
            $min_x = $s{"x"};
        }
        if($s{"x"} > $max_x)
        {
            $max_x = $s{"x"};
        }
        
        if($s{"y"} < $min_y)
        {
            $min_x = $s{"y"};
        }
        if($s{"y"} > $max_y)
        {
            $max_y = $s{"y"};
        }
        
        $stars[$j] = \%s;
    
    }
    
    if(not defined $min_x_d or ($max_x - $min_x < $min_x_d))
    {
        $min_x_d = $max_x - $min_x;
        $min_x_iter = $i;
    }
    if(not defined $min_y_d or ($max_y - $min_y < $min_y_d))
    {
        $min_y_d = $max_y - $min_y;
        $min_y_iter = $i;
    }
    
    if($min_x_iter == $i)
    {
        print("saving min x image...\n");
        my $image = Image::Base::GD->new (-width => $largest,
                                          -height => $largest);
      
        # draw white background
        $image->rectangle (0,0, $largest * 2,$largest * 2, 'white');
        
        for(my $j = 0; $j < scalar(@stars); $j += 1)
        {
            my $st = $stars[$j];
            my %s = %{$st};
            $image->xy ($largest - $s{"x"}, $largest - $s{"y"}, 'red');

        }
        $image->save ('min_x.png');
        $x_saved = 1;
        
    }
    if($min_y_iter == $i)
    {
        print("saving min y image...\n");
        my $image = Image::Base::GD->new (-width => $largest,
                                          -height => $largest);
        
        # draw white background
        $image->rectangle (0,0, $largest * 2,$largest * 2, 'white');

        
        for(my $j = 0; $j < scalar(@stars); $j += 1)
        {
            my $st = $stars[$j];
            my %s = %{$st};
            $image->xy ($largest - $s{"x"}, $largest - $s{"y"}, 'red');

        }
        $image->save ('min_y.png');
        $y_saved = 1;
    }
    
    # inform the user that we're still working here...
    if($i % 1000 == 0)
    {
        print("iter $i...\n");
    }
    
    # if we saved both images, quit
    if($x_saved and $y_saved)
    {
        last;
    }
}
