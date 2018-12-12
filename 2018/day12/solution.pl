use strict;
use warnings;

my ($num_gens) = @ARGV;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;

# get initial state
my $state = "";
my $sum_live = 0;
my %rules;

# load rules
foreach my $itm (@list)
{
    # loading initial state?
    if($itm =~ /.*initial state.*/)
    {
        my $init_state_index = index($itm, ": ");
        # get initial state, adjusting for trailing newline
        $state = substr($itm, $init_state_index + 2, (length $itm) - $init_state_index - 3);
        print("State:\n$state\n");
    }
    if($itm =~ /.*=>.*/)
    {
        my $eq_index = index($itm, "=>");
        my $rule = substr($itm, 0, $eq_index - 1);
        my $result = substr($itm, $eq_index + 3, 1);
        $rule =~ s/\r//g;
        $result =~ s/\r//g;
        $rules{$rule} = $result;
        
        print("rule: '$rule', result: '" . $rules{$rule} . "'\n");
    }
}
$state = $state . "..";
print("\n$state\n");
print("Original length: " . (length $state) . "\n");
# iterate 20 generations
for(my $gen = 1; $gen <= $num_gens; $gen += 1)
{
    if($gen % 1000 == 0)
    {
        print("Gen $gen complete.\n");
    }

    # create next generation's state
    my $ng = "";
    
    # iterate indexes of string (string may adjust in size)
    my $len = length $state;
    
    #$state = ".." . $state . "..";
    #print("cur adj state: $state\n");
    for(my $i = -3; $i <= $len; $i += 1)
    {
        #print("$i, $len\n");
        # does this plus its neighbors match a rule? (they all should)
        my $subs = "";
        
        # if we can take a substring of 5, do it
        
        $subs = substr("..." . $state . "..", $i + 3, 5);
        $subs =~ s/\r//g;

        # print(">" . substr(".." . $state . "...", $i + 1, 5) . "\n");
        # print(">>" . substr(".." . $state . "...", $i + 2, 5) . "\n");
        # print(">>>" . substr(".." . $state . "...", $i + 3, 5) . "\n");
        # if($i >= 0 and $len - $i > 4)
        # {
            # $subs = substr($state, $i, 5);
        # }
        # # otherwise take what you can and we'll pad it
        # else
        # {
            # print("nok\n");
            # $subs = substr(".." . $state . "..", $i + 2, 5);

            # # if($i < 0)
            # # {
                # # $subs = substr($state, 0, 5 + $i);
            # # }
            # # else
            # # {
                # # print("getting what I can: $i, $len, " . ($len - $i) . "\n");
                # # $subs = substr($state, $i, $len - $i);
                # # print(">>>$subs\n");
            # # }
        # }
        
        # pad to 5 characters
        while(length $subs < 5)
        {
            # pad to left or right?
            if($i < 3)
            {
                $subs = "." . $subs;
            }
            else
            {
                #print("appending...\n");
                $subs = $subs . ".";
            }
        }

        #print("'$subs'\n");# (" . (length $subs) . "), $i\n");
        #print("subs: $subs, $i\n");
        # if so, add the resulting state
        #print("new state: " . $rules{$subs} . "\n");
        # does the rule exist?
        if(not exists $rules{$subs})
        {
            $rules{$subs} = ".";
            #print("new rule: $subs, result: " . $rules{$subs} . "\n");
        }
        
        # save new result
        #print($ng . "\n");
        #print("appending '" . $rules{$subs} . "'\n\n");
        $ng = $ng . $rules{$subs};
        #print($ng . "\n");
        
        # count live plants, increment sum
        if($rules{$subs} eq "#")
        {
            $sum_live += 1;
        }
    
    }
    
    # save new state
    $state = $ng;
    
    #print("$gen: " . $state . "\n");
    
    my $new_sum = 0;
    my $num_alive = 0;
    for(my $i = 0; $i < length $state; $i += 1)
    {
        if(substr($state, $i, 1) eq "#")
        {
            $new_sum += $i - $gen;
            $num_alive += 1;
        }
    }

    print("Gen $gen: There are $num_alive living plants (index sum $new_sum).\n");
}

print("New length: " . (length $state) . "\n");

my $new_sum = 0;
for(my $i = 0; $i < length $state; $i += 1)
{
    if(substr($state, $i, 1) eq "#")
    {
        $new_sum += $i - 20;
    }
}

print("There were $sum_live living plants (index sum $new_sum).\n");
