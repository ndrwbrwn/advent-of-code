use List::Util qw/ uniq /;
my @grid;
my %reach;

push @grid, [split('', $_)] while (<>);

foreach my $i (-1 .. scalar(@grid)) {
	foreach my $j (-1 .. scalar(@grid)) {
		$reach{key($i,$j)} = [];
	}
}

foreach my $i (0 .. scalar(@grid)-1) {
	foreach my $j (0 .. scalar(@grid)-1) {
		next unless ($grid[$i][$j] eq "0");
		
		my @paths = @{dfs($i,$j)};
		$c_one += scalar(uniq @paths);
		$c_two += scalar(@paths);
	}
}

print "Part One\n";
print $c_one . "\n";
print "Part Two\n";
print $c_two . "\n";

sub dfs
{
	my ($i, $j) = @_;
	my $key = key($i,$j);

	DONE: {
		last DONE if ($i < 0 or $i >= scalar(@grid) or $j < 0 or $j >= scalar(@grid) or scalar(@{ $reach{$key} } ));

		if ($grid[$i][$j] eq "9") {
			push @{ $reach{$key} }, $key;
			last DONE;
		}

		foreach ([0, 1], [0, -1], [1, 0], [-1, 0]) {
			my @dir = @{$_};
			next unless ($grid[$i+$dir[0]][$j+$dir[1]] eq $grid[$i][$j]+1);

			my @reach_peaks = @{ dfs($i+$dir[0], $j+$dir[1]) };
			foreach my $peak (@reach_peaks) {
				push @{ $reach{$key} }, $peak; # unless (grep {$_ eq $peak} @{ $reach{$key} });
			}
		}
	}

	return $reach{$key};
}

sub key
{
	return sprintf "%d:%d", @_;
}
