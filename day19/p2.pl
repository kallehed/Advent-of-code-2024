#!/bin/perl

# read patterns from first line
my $first_line = <>;
chomp $first_line;
my @patterns = split /,\s*/, $first_line;

# skip empty line
<>;

my %memo;

sub count_ways {
    my ($str) = @_; # arg
    return $memo{$str} if exists $memo{$str};

    return 1 if $str eq '';  # empty string

    my $ways = 0;
    for my $pattern (@patterns) {
        if ($str =~ /^\Q$pattern\E(.*)$/) {
            $ways += count_ways($1);
        }
    }

    return $memo{$str} = $ways;
}

my $total = 0;
while (my $line = <>) {
    chomp $line;
    next if $line eq '';

    my $ways = count_ways($line);
    $total += $ways;
    print "$line: $ways ways\n";
}
print "total: $total";
