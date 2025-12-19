my @one, @two;
my $dist;

while (<>) {
	if ($_ =~ /(\d+)\s+(\d+)/) {
		push @one, $1;
		push @two, $2;
	}
}

@one = sort {$a <=> $b} @one;
@two = sort {$a <=> $b} @two;

for my $i (0 .. scalar(@one)) {
	$dist += abs (@one[$i] - @two[$i]);
}

print "Part One\n";
print $dist . "\n";

my %count;
my $score;

foreach (@two) $count{$_}++;
foreach (@one) $score += $_ * $count{$_};

print "Part Two\n";
print $score . "\n";
