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

# for problem 2
my $num_workers = 5;
my $time_minimum = 60;
my %helpers;

# iterate input list, build steps
foreach my $itm (@list)
{
    my $split_loc = index($itm, "step");
    
    my $req_step = substr($itm, 5, 1);
    my $cur_step = substr($itm, $split_loc + 5, 1);
    
    # print "step $cur_step reqs step $req_step\n";
    
    if (not exists $steps{$cur_step})
    {
        @steps{$cur_step} = ();
    }
    push @{$steps{$cur_step}}, $req_step;
}

# print setup, for fun
foreach my $alpha (@alphabet)
{
    print "$alpha < (";
    if (exists $steps{$alpha})
    {
        # print $steps{$alpha} . ", ";
        
        for (my $i = 0; $i < scalar(@{$steps{$alpha}}); $i += 1)
        {
            print @{$steps{$alpha}}[$i] . ", ";
        }
    }
    print ")\n";
}

# this is what's being or has been worked on; don't grab duplicates!
my @working_order = ();
# track time (problem 2)
my $time = -1;
# track length of completed string
my $compl_len = scalar(@completion_order);

# while we aren't done, loop through workers
while ( $compl_len < scalar(@alphabet))
{
    for (my $worker = 0; $worker < $num_workers; $worker += 1)
    {
        if (not exists $helpers{$worker})
        {
            # init and get ready to work
            $helpers{$worker}{"cur_letter"} = '.';
            $helpers{$worker}{"time_rem"} = 0;
            $helpers{$worker}{"can_work"} = 1;
        }
        else
        {
            $helpers{$worker}{"can_work"} = 1;
            # check if done and can move on
            if ($helpers{$worker}{"time_rem"} == 0 and $helpers{$worker}{"cur_letter"} ne ".")
            {
                push @completion_order, $helpers{$worker}{"cur_letter"};
            
                # iterate all letters again and remove instances of this key
                for (my $j = 0; $j < scalar(@alphabet); $j += 1)
                {
                    my @new_list = ();
                    foreach my $cur_itm (@{$steps{$alphabet[$j]}})
                    {
                        if ($cur_itm ne $helpers{$worker}{"cur_letter"})
                        {
                            push @new_list, $cur_itm;
                        }
                    }
                    @{$steps{$alphabet[$j]}} = @new_list;
                    
                }
                
                # reset their working letter (period for debug printing)
                $helpers{$worker}{"cur_letter"} = ".";
                
            }
            else
            {
                # reduce time for worker, they can't work this second
                if ($helpers{$worker}{"time_rem"} > 0)
                {
                    $helpers{$worker}{"time_rem"} -= 1;
                    $helpers{$worker}{"can_work"} = 0;
                }
            }
        }
    }
    for (my $worker = 0; $worker < $num_workers; $worker += 1)
    {
        # if this helper can work, work
        if ($helpers{$worker}{"can_work"})
        {
            # iterate alpha
            for (my $i = 0; $i < scalar(@alphabet); $i += 1)
            {
                my $k = $alphabet[$i];
                my $already_checked = 0;
                
                # have we worked on this letter before?
                for (my $j = 0; $j < scalar(@working_order); $j += 1)
                {
                    if ($working_order[$j] eq $k)
                    {
                        $already_checked = 1;
                        last;
                    }
                }
                # if we haven't already started work on this letter,
                # start
                if (not $already_checked)
                {
                    # get dependencies, if any exist
                    my @v = ();
                    if (exists $steps{$k})
                    {
                        @v = @{$steps{$k}};
                    }
                    
                    # get length of dependencies
                    my $v_l = scalar(@v);

                    if ($v_l == 0)
                    {
                        # give to worker
                        $helpers{$worker}{"cur_letter"} = $k;
                        
                        # calculate time; adjust for ASCII
                        $helpers{$worker}{"time_rem"} = $time_minimum + ord($k) - 65;
                        # remove from the open queue
                        delete $steps{$k};
                        # notify others not to work on it
                        push @working_order, $k;
                        # break
                        last;
                    }
                }
            }
        }
    }
    
    # recalculate our completed code length
    $compl_len = scalar(@completion_order);
    
    $time += 1;
}

# print for fun
print "Completion order:\n";
foreach my $itm (@completion_order)
{
    print "$itm";
}
print "\n";

# solution 2
print "Time: $time\n";
