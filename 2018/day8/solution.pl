use strict;
use warnings;

# open file contents to $fh
my $filename = 'input.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get list from file contents
my $list = <$fh>;

my $meta_sum = 0;

# solve recursively
sub problem
{
    # get argument (remaining string to parse)
    my ($rem_str) = @_;
    
    # sum of this node
    my $local_meta_sum = 0;
    
    # list of this node's children's values
    my @children = ();
    
    # get quantity of child nodes
    my $next_space = index($rem_str, " ");
    my $num_child_nodes = substr($rem_str, 0, $next_space);
    $rem_str = substr($rem_str, $next_space + 1, (length $rem_str) - $next_space);
    
    # get quantity of metadata entries
    $next_space = index($rem_str, " ");
    my $num_meta_nodes = substr($rem_str, 0, $next_space);
    $rem_str = substr($rem_str, $next_space + 1, (length $rem_str) - $next_space);
    
    # process for each child node
    for(my $i = 0; $i < $num_child_nodes; $i += 1)
    {
        my $val_child = 0;
        ($rem_str, $val_child) = problem($rem_str);
        
        # push this child's values onto the list
        push @children, $val_child;
    }
    
    # get values from meta nodes
    for(my $i = 0; $i < $num_meta_nodes; $i += 1)
    {
        $next_space = index($rem_str, " ");
        my $meta_node = substr($rem_str, 0, $next_space);
        $rem_str = substr($rem_str, $next_space + 1, (length $rem_str) - $next_space);
        
        # problem 1
        $meta_sum += $meta_node;
        
        # problem 2
        # if no children, sum metanodes
        if(scalar(@children) == 0)
        {
            $local_meta_sum += $meta_node;
        }
        else
        {
            # if the node refers to a child, get value of child
            # else skip
            if($meta_node <= scalar(@children) and $meta_node > 0)
            {
                $local_meta_sum += $children[$meta_node - 1];
            }
        }
        
    }
    
    return ($rem_str, $local_meta_sum);
}

my ($rem_str, $val_first_node) = problem($list);

# problem 1
print("Sum of meta nodes: $meta_sum\n");

# problem 2
print("Value of first node: $val_first_node\n")
