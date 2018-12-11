use strict;
use warnings;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;
my @stars = ();

# i guess i'm just going to make one big 2d array...?
my @grid = ();
my $max_w = 5;
my $max_h = 5;
for (my $i = 0; $i < $max_w; $i += 1)
{
    @grid[$i] = ();
    
    for (my $j = 0; $j < $max_h; $j += 1)
    {
        # create grid point
        $grid[$i][$j] = '.';
        
        # # create list to keep track of all
        # # closest source coordinates
        # $grid[$i][$j]{"closest"} = ();
      
        # # manhattan distance to the nearest
        # # source coordinate(s)
        # $grid[$i][$j]{"dist"} = $max_w + $max_h + 1;
        
        # # used for problem 2
        # # sum distance to all source coordinates
        # $grid[$i][$j]{"dist_to_all"} = 0;
        
        
    }
}

# parse data from text file
foreach my $itm (@list)
{
    #print($itm);
    
    my $rem_str = $itm;

    my $next = index($rem_str, "<");
    my $sep = index($rem_str, ",");
    my $end = index($rem_str, ">");
    
    my $x = substr($rem_str, $next + 1, $sep - $next - 1);
    my $y = substr($rem_str, $sep + 2, $end - $sep - 2);
   # print("x, y: ('$x', '$y')\n");
    
    $rem_str = substr($rem_str, $end + 1, (length $rem_str) - $end);
    
    $next = index($rem_str, "<");
    $sep = index($rem_str, ",");
    $end = index($rem_str, ">");
    
    my $vx = substr($rem_str, $next + 1, $sep - $next - 1);
    my $vy = substr($rem_str, $sep + 2, $end - $sep - 2);
    
    #print("vx, vy: ($vx, $vy)\n");
    
    # push @stars, {};
    # my %star;
    # $star{"x"} = $x;
    # $star{"y"} = $y;
    # $star{"vx"} = $vx;
    # $star{"vy"} = $vy;
    
    # #push @stars, {};
    # $stars[scalar(@stars)] = %star;
    
}

# while(1)
# {
    foreach my $star (@stars)
    {
        #my %st = $star;
        #print(@($star)["x"] . "\n");
        #print(%{$star}{'x'});
        # while(my($k, $v) = each %star) 
        # {
            # print(">>>$k, $v\n");
        
        # }
    }
# }
