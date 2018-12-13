use strict;
use warnings;

my ($fn, $debug) = @ARGV;

# open file contents to $fh
my $filename = $fn;
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;

# build map (2d array of chars)
print "initializing grid...\n";
my @grid = ();
my @movers = ();

for(my $ln = 0; $ln < scalar(@list); $ln += 1) #each my $line (@list)
{
    #@grid[$ln] = ();
    push(@grid, ());
    my $line = $list[$ln];
    # print("    ");
    # for(my $i = 0; $i < length $line; $i += 1)
    # {
        # print($i . " ");
    # }
    
    # print("\n($ln) ");
    
    for(my $i = 0; $i < length $line; $i += 1)
    {
        my $char = substr($line, $i, 1);
        
        #print($char . " ");
        # get each mover (position, direction, turn order)
        if($char eq '<' or
            $char eq '>' or
            $char eq 'v' or
            $char eq '^')
        {
            my %mover;
            $mover{'c'} = $char;
            $mover{'x'} = $i;
            $mover{'y'} = $ln;
            $mover{'d'} = 0;
            if($char eq '<')
            {
                $mover{'vx'} = -1;
                $mover{'vy'} = 0;
            }
            if($char eq '>')
            {
                $mover{'vx'} = 1;
                $mover{'vy'} = 0;
            }
            if($char eq '^')
            {
                $mover{'vx'} = 0;
                $mover{'vy'} = -1;
            }
            if($char eq 'v')
            {
                $mover{'vx'} = 0;
                $mover{'vy'} = 1;
            }
            
            
            push(@movers, \%mover);
            #print("Length of movers: " . scalar(@movers) . "\n");
            # print($movers[0]{"x"} . "\n");
            # #$movers[scalar(@movers)] = %mover;
            # print("new mover: $char at (" . $mover{'x'} . ", " . $mover{'y'} . ")\n");
            
            push(@{$grid[$ln]}, '.');
        }
        else
        {
            push(@{$grid[$ln]}, $char);
        }
    }
    # print("\n");
}

# my %y = %{$movers[0]};
# print($y{'x'} . "\n");

# for(my $y = 0; $y < 6; $y += 1)
# {
    # for(my $x = 0; $x < 15; $x += 1)
    # {
        # print($grid[$y][$x]);
    # }
    # print("\n");
# }

sub printg
{
    #print(">>>" . scalar(@grid) . ",");
    for(my $i = 0; $i < scalar(@grid); $i += 1)
    {
        #print(@grid[$i]);
        
        #print(scalar(@{$grid[$i]}) . "\n");
        for(my $j = 0; $j < scalar(@{$grid[$i]}); $j += 1)
        {
            my $thischar = undef;#$grid[$i][$j]
            #print("$i, $j\n");
            
            for(my $m = 0; $m < scalar(@movers); $m += 1)# (@movers)
            {
                my %mover = %{$movers[$m]};
                if($mover{'x'} == $j and $mover{'y'} == $i)
                {
                    $thischar = $mover{'c'};
                }
            }
            if(not defined $thischar)
            {
                $thischar = $grid[$i][$j];
            }
            print($thischar);
            
            
        }
    }
}

# put movers in x, y order
sub resort
{
    my @new_movers = ();
   
    # while there are still movers, find lowest x/y value and push that to new_movers, remove from movers?
    for(my $m = 0; $m < scalar(@movers); $m += 1)# (@movers)
    {
        my %mover = %{$movers[$m]};
        
        
        
        
        
        
        
        
        
        
    }

    return @new_movers;

}

my $num_cycles = 1;
while(1)#$num_cycles < 3)
{
    # print iteration
    #print("Iteration $num_cycles\n");
    
    # collision?
    my $collision = 0;
    
    # @movers = resort();
    # print(scalar(@movers));
    
    # for each mover
    for(my $m = 0; $m < scalar(@movers); $m += 1)# (@movers)
    {
        my %mover = %{$movers[$m]};
        
        
        
        my %newmover;
        
        
        
        $newmover{'x'} = $mover{'x'};
        $newmover{'y'} = $mover{'y'};
        $newmover{'vx'} = $mover{'vx'};
        $newmover{'vy'} = $mover{'vy'};
        $newmover{'c'} = $mover{'c'};
        $newmover{'d'} = $mover{'d'};
        
        
        # print("\n");
        # while(my($k, $v) = each %mover) 
        # {
            # print("$k, $v\n");
        # }
        # print($mover{'x'} . "\n");
    
        #print(scalar(@grid) . ", " . scalar(@{$grid[0]}) . "\n");
        #print("($m) x, y: " . $mover{'x'} . ", " . $mover{'y'} . "\n");
    
        # move ahead one
        $newmover{'x'} = $mover{'x'} + $mover{'vx'};
        $newmover{'y'} = $mover{'y'} + $mover{'vy'};
        
        #print($grid[$mover{'y'}][$mover{'x'}] . "\n");
        
        # check char in equivalent position in map
        # rotate accordingly
        $newmover{'c'} = $mover{'c'};
        if($grid[$newmover{'y'}][$newmover{'x'}] eq '/')
        {
            if($newmover{'c'} eq '^')
            {
                $newmover{'vx'} = 1;
                $newmover{'vy'} = 0;
                $newmover{'c'} = '>';
            }
            elsif($newmover{'c'} eq '<')
            {
                $newmover{'vx'} = 0;
                $newmover{'vy'} = 1;
                $newmover{'c'} = 'v';
            }
            elsif($newmover{'c'} eq 'v')
            {
                $newmover{'vx'} = -1;
                $newmover{'vy'} = 0;
                $newmover{'c'} = '<';
            }
            elsif($newmover{'c'} eq '>')
            {
                $newmover{'vx'} = 0;
                $newmover{'vy'} = -1;
                $newmover{'c'} = '^';
            }
        }
        elsif($grid[$newmover{'y'}][$newmover{'x'}] eq '\\')
        {
            if($newmover{'c'} eq '^')
            {
                $newmover{'vx'} = -1;
                $newmover{'vy'} = 0;
                $newmover{'c'} = '<';
            }
            elsif($newmover{'c'} eq '<')
            {
                $newmover{'vx'} = 0;
                $newmover{'vy'} = -1;
                $newmover{'c'} = '^';
            }
            elsif($newmover{'c'} eq 'v')
            {
                $newmover{'vx'} = 1;
                $newmover{'vy'} = 0;
                $newmover{'c'} = '>';
            }
            elsif($newmover{'c'} eq '>')
            {
                $newmover{'vx'} = 0;
                $newmover{'vy'} = 1;
                $newmover{'c'} = 'v';
            }
        }
        elsif($grid[$newmover{'y'}][$newmover{'x'}] eq '+')
        {
            # first intersection: go left
            if($newmover{'d'} == 0)
            {
                if($newmover{'c'} eq '^')
                {
                    $newmover{'vx'} = -1;
                    $newmover{'vy'} = 0;
                    $newmover{'c'} = '<';
                }
                elsif($newmover{'c'} eq '<')
                {
                    $newmover{'vx'} = 0;
                    $newmover{'vy'} = 1;
                    $newmover{'c'} = 'v';
                }
                elsif($newmover{'c'} eq 'v')
                {
                    $newmover{'vx'} = 1;
                    $newmover{'vy'} = 0;
                    $newmover{'c'} = '>';
                }
                elsif($newmover{'c'} eq '>')
                {
                    $newmover{'vx'} = 0;
                    $newmover{'vy'} = -1;
                    $newmover{'c'} = '^';
                }
                $newmover{'d'} = $newmover{'d'} + 1;
            }
            # second intersection: go straight
            elsif($newmover{'d'} == 1)
            {
                $newmover{'d'} = $newmover{'d'} + 1;
            }
            # third intersection: go right and reset
            elsif($newmover{'d'} == 2)
            {
                if($newmover{'c'} eq 'v')
                {
                    $newmover{'vx'} = -1;
                    $newmover{'vy'} = 0;
                    $newmover{'c'} = '<';
                }
                elsif($newmover{'c'} eq '>')
                {
                    $newmover{'vx'} = 0;
                    $newmover{'vy'} = 1;
                    $newmover{'c'} = 'v';
                }
                elsif($newmover{'c'} eq '^')
                {
                    $newmover{'vx'} = 1;
                    $newmover{'vy'} = 0;
                    $newmover{'c'} = '>';
                }
                elsif($newmover{'c'} eq '<')
                {
                    $newmover{'vx'} = 0;
                    $newmover{'vy'} = -1;
                    $newmover{'c'} = '^';
                }
                $newmover{'d'} = 0;
            }
            
        }
        
        #check grid now to see if we're phasing through anyone
        for(my $j = 0; $j < scalar(@movers); $j += 1)
        {
            # if position is same: collision
            if($newmover{'c'} ne $movers[$j]{'c'})
            {
                if($newmover{'x'} == $movers[$j]{'x'} and
                    $newmover{'y'} == $movers[$j]{'y'})
                {
                    print("Collision at " . $newmover{'x'} . ", " . $newmover{'y'} . "!\n");
                    print($newmover{'c'} . " vs " . $movers[$j]{'c'} . "\n");
                    $collision = 1;
                    printg();
                    last;
                }
            }
        }
        
        $movers[$m] = \%newmover;
        
        #print("mover: " . $newmover{'c'} . " " . $newmover{'x'} . ", " . $newmover{'y'} . "\n");
    }

    
    if(defined $debug)
    {
        printg();
    }
    
    # check all movers after we have moved them all already for this cycle
    for(my $i = 0; $i < scalar(@movers); $i += 1)
    {
        for(my $j = 0; $j < scalar(@movers); $j += 1)
        {
            # if position is same: collision
            if($i != $j)
            {
                if($movers[$i]{'x'} == $movers[$j]{'x'} and
                    $movers[$i]{'y'} == $movers[$j]{'y'})
                {
                    print("Collision at " . $movers[$i]{'x'} . ", " . $movers[$i]{'y'} . "!\n");
                    print($movers[$i]{'c'} . " vs " . $movers[$j]{'c'} . "\n");
                    $collision = 1;
                    last;
                }
            }
        }
    }
    
    if($collision)
    {
        last;
    }
    
    if($num_cycles % 100 == 0)
    {
        print("Iteration $num_cycles\n");
    }
    
    $num_cycles += 1;
    
    if(defined $debug and $debug eq 'd')
    {
        my $name = <STDIN>;
    }
}

print("First collision found at cycle $num_cycles\n");
