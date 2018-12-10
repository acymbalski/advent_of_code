use strict;
use warnings;

# run:
# perl solution.pl 10 1618
my ($num_players, $num_marbles) = @ARGV;

print("Running $num_players players with $num_marbles marbles...\n");

my $current_player = 1;
my @players = ();

# doubly-linked list
my $head = {data => 0, prev => undef, next => undef};
$head->{next} = $head;
$head->{prev} = $head;
my $previous = $head;
my $current = $head;

# 1-based list (this is dumb and useless)
$num_players += 1;

for (my $i = 0; $i < $num_players; $i += 1)
{
    $players[$i] = 0;
}

# an incredibly stupid way of implementing a circular array
# this is left here as a trophy of shame (works, though)
sub get_adj_index
{
    # type_index = 1 or 0-based
    my ($list_len, $cur_index, $amt, $type_index) = @_;

    # default type_index value is 0 (0-based list)
    if(not defined $type_index)
    {
        $type_index = 0;
    }

    my $sum_amt = $cur_index + $amt;

    if($sum_amt < 0 + $type_index)
    {
        return ($list_len - $type_index) + $sum_amt;
    }
    else
    {
        if($sum_amt > $list_len - $type_index)
        {
            return $amt - ($list_len - $cur_index) + $type_index;
        }
        else
        {
            return $sum_amt;
        }
    }
}

# list seek
sub lseek
{
    my ($amt) = @_;

    if($amt > 0)
    {
        for(my $i = 0; $i < $amt; $i += 1)
        {
            $current = $current->{next};
        }
    }
    else
    {
        for(my $i = 0; $i < -$amt; $i += 1)
        {
            $current = $current->{prev};
        }
    }

}

# list add
# (adds value to linked list at $current location)
sub ladd
{
    my ($val) = @_;

    my $new = {"data" => $val, "prev" => $current, "next" => $current->{next}};

    $current = $new;
    $current->{next}->{prev} = $current;
    $current->{prev}->{next} = $current;
}

sub rem
{
    $current->{prev}->{next} = $current->{next};
    $current->{next}->{prev} = $current->{prev};
    $current = $current->{next};
}

sub print_turn
{
    print("[" . $current_player . "] ");
    
    my $curr = $head;
    
    print($head->{data} . " ");
    $curr = $head->{next};
    
    while(($curr->{data} != $head->{data}))
    {
        if($curr->{data} == $current->{data})
        {
            print("(" . $curr->{data} . ") ");
        }
        else
        {
            print($curr->{data} . " ");
        }
        $curr = $curr->{next};
    }
    print("\n");
}

for(my $i = 1; $i <= $num_marbles; $i += 1)
{
    # if marble is multiple of 23
    if($i % 23 == 0)
    {
        # add to current player's score
        $players[$current_player] += $i;
        # take marble 7 left of current marble
        lseek(-7);
        $players[$current_player] += $current->{data};
        
        # remove marble from game
        rem();
    }
    else
    {
        # else, add marble b/w 1 and 2 to the right
        lseek(1);
        ladd($i);
    }
    
    $current_player = get_adj_index($num_players, $current_player, 1, 1);
}

# find max score, player
my $max_index = 0;
my $max_score = $players[$max_index];

for (my $i = 1; $i < $num_players; $i += 1)
{
    if($players[$i] > $max_score)
    {
        $max_index = $i;
        $max_score = $players[$i];
    }
}

print("Player $max_index has the largest score: $max_score\n");
