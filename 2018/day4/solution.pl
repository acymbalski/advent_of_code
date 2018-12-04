use strict;

# picked the wrong challenge to spontaneously try perl on
# technically works though

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
# sort alpha
sub alphabetical {
    # compares lower-cased versions of the strings
    lc($a) cmp lc($b);

}

# create list of each line in the file, sorted alphabetically
# (sorting via alpha will put it in time order due to the way the time was written)
my @list = sort alphabetical <$fh>;

# create guards dict
my %guards;
# which guard ID is currently "on duty"
my $active_guard;
# keep track of when that guard fell asleep for looping
my $asleep_min;

foreach my $itm (@list)
{
    # guard begins shift
    # match regex
    if ($itm =~ /.*begins shift.*/)
    {
        # get substring of guard's ID number
        my $num_start = index($itm, "#") + 1;
        my $num_end = index($itm, " begins");
        
        $active_guard = substr($itm, $num_start, $num_end - $num_start);
    }
    
    # guard falls asleep
    if ($itm =~ /.*falls asleep.*/)
    {
        # get substring of the minute the guard fell asleep
        # we are fortunate they all fall asleep between midnight and 1am
        my $num_start = index($itm, ":") + 1;
        my $num_end = index($itm, "]");
        
        $asleep_min = substr($itm, $num_start, $num_end - $num_start);
        
    }
    if ($itm =~ /.*wakes up.*/)
    {
        # get substring of when guard wakes up
        # same minute trick as above
        my $num_start = index($itm, ":") + 1;
        my $num_end = index($itm, "]");
        
        my $awake_min = substr($itm, $num_start, $num_end - $num_start);
        
        # if key doesn't exist in the hash, create it with an empty array
        if (not exists $guards{$active_guard})
        {
            @{$guards{$active_guard}} = ();
        }
        
        # since we need the most common minute asleep later, loop through all sleeping minutes and push/append them into the array for this guard
        # we will sort later
        for (my $i=$asleep_min; $i < $awake_min; $i++)
        {
            push @{$guards{$active_guard}}, $i;
        }
    }
}

# find the sleepiest guard
# reset hash iterator
keys %guards;

# used for solution 2
my $most_consistent_guard = $active_guard;
my $mode_most_consistent = -1;
my $num_occurances = -1;


# iterate
# $active_guard will hold the current sleepiest
while(my($k, $v) = each %guards) 
{
    # convert scalar value to array
    my @v = @{$v};
    
    # now taking scalar of that array gives us length
    # compare via the current $active_guard id to determine sleepiest
    # note that we didn't reset the active_guard; we didn't really have to
    if (scalar @v > scalar @{$guards{$active_guard}})
    {
       $active_guard = $k;
    }
    
    my %count;
    # we store the values and their frequency in a hash
    map{ $count{$_}++ } @{$guards{$k}};
    # sort the hash by values
    my $j;
    # use the mode-finder mentioned later, only we're trying to see who had the mode that appeared the most (the mode-iest) instead of what the biggest mode of one guy is
    for $j ( sort {$count{$a} <=> $count{$b}} keys %count ) {
        # if this mode shows up more than our last best...
        if ($count{$j} > $num_occurances)
        {
            # keep track of the frequency
            $num_occurances = $count{$j};
            # keep track of the minute
            $mode_most_consistent = $j;
            # keep track of the guard ID
            $most_consistent_guard = $k;
        }
    }
    
}

# init mode
# we multiply later. if we have a negative result, you know something went wrong
my $mode = -1;

# stolen from http://forums.devshed.com/perl-programming-6/mode-value-array-288530.html
# i do not understand the "for" line...
my %count;
# we store the values and their frequency in a hash
map{ $count{$_}++ } @{$guards{$active_guard}};
# sort the hash by values
my $k;
for $k ( sort {$count{$a} <=> $count{$b}} keys %count ) {
    # the last one printed is the most frequent one
    $mode = $k;
}


# print results!
# solution 1
print "Sleepiest Guard: #" . $active_guard . "\n";
print "Sleepiest minute: " . $mode . "\n";
print "id*min: " . $active_guard * $mode . "\n\n";

# solution 2
print "Most consistent guard: #" . $most_consistent_guard . "\n";
print "Sleepiest minute: " . $mode_most_consistent . "\n";
print "id*min: " . $most_consistent_guard * $mode_most_consistent . "\n";
