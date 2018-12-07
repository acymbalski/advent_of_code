use strict;
use warnings;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my @list = <$fh>;

# hash of steps, reqs
my %steps;
my @completion_order = ();

# init alphabet since not all letters are listed in the input
my @alphabet = ('A'..'Z');

# iterate input list, build steps
foreach my $itm (@list)
{
    my $split_loc = index($itm, "step");
    
    my $req_step = substr($itm, 5, 1);
    my $cur_step = substr($itm, $split_loc + 5, 1);
    
    if (not exists $steps{$cur_step})
    {
        @steps{$cur_step} = ();
    }
    push @{$steps{$cur_step}}, $req_step;
}

# print setup
foreach my $alpha (@alphabet)
{
    print "$alpha < (";
    if (exists $steps{$alpha})
    {
        for (my $i = 0; $i < scalar(@{$steps{$alpha}}); $i += 1)
        {
            print @{$steps{$alpha}}[$i] . ", ";
        }
    }
    print ")\n";
}

# solve; iterate alphabetically
for (my $i = 0; $i < scalar(@alphabet); $i += 1)
{
    my $k = $alphabet[$i];
    my $already_checked = 0;
    
    for (my $j = 0; $j < scalar(@completion_order); $j += 1)
    {
        if ($completion_order[$j] eq $k)
        {
            # if we've already finished this letter, don't check again
            $already_checked = 1;
            last;
        }
    }
    if (not $already_checked)
    {
        # get list of dependencies, if they exist
        my @v = ();
        
        if (exists $steps{$k})
        {
            @v = @{$steps{$k}};
        }
        
        # get number of dependencies
        my $v_l = scalar(@v);

        # if we have no dependencies, we can finish it now
        if ($v_l == 0)
        {
            # push to completed list
            push @completion_order, $k;
            # remove from hash
            delete $steps{$k};
            
            # restart alpha
            $i = -1;
        
            # iterate all letters again and remove instances of this key
            # not finding an easy way to remove from an array in perl :(
            for (my $j = 0; $j < scalar(@alphabet); $j += 1)
            {
                my @new_list = ();
                foreach my $cur_itm (@{$steps{$alphabet[$j]}})
                {
                    if ($cur_itm ne $k)
                    {
                        push @new_list, $cur_itm;
                    }
                }
                @{$steps{$alphabet[$j]}} = @new_list;
            }
        }
    }
}

# solution 1
print "Completion order:\n";

foreach my $itm (@completion_order)
{
    print "$itm";
}
print "\n";
