my @grid;

push @grid, [split('', $_)] while (<>);

my ($i, $j);
SEARCH: for ($i = 0; $i < scalar(@grid); $i++) {
	for ($j = 0; $j < scalar(@grid); $j++) {
		last SEARCH if ($grid[$i][$j] eq "^");
	}
}

my $d = 0;
my @v;
my $magic_cross_count = 0;

while (@v = movedir($i, $j, $d)) {
	$d = ($d + 1) % 4;
	($i, $j) = @v;

	last if ((!defined $i) || (!defined $j));
	print "Turned. Going " . $d . " from (" . $i . " , " . $j . ")\n";
}

my $c;
for ($i = 0; $i < scalar(@grid); $i++) {
	for ($j = 0; $j < scalar(@grid); $j++) {
		$c++ if ($grid[$i][$j] eq "X");
	}
}

print "Part One\n";
print $c . "\n";
print "Part Two\n";
print $magic_cross_count . "\n";
#6026 too high

sub movedir
{
	my ($i, $j, $d) = @_;

	RUN: {
		if ($d == 2) {
			my $b = $i;
			$grid[$b++][$j] = "Y" while (!($grid[$b][$j] eq "#") && $b != scalar(@grid));

			while (!($grid[$i][$j] eq "#")) {
				$magic_cross_count++ if ($grid[$i][$j] eq "X" || $grid[$i][$j] eq "Y");
				$grid[$i][$j] = "X";
				last RUN if ($i == scalar(@grid)-1);
				$i++;
			}
			return ($i-1, $j);
		}

		if ($d == 0) {
			my $b = $i;
			$grid[$b--][$j] = "Y" while (!($grid[$b][$j] eq "#") && $b != -1);

			while (!($grid[$i][$j] eq "#")) {
				$magic_cross_count++ if ($grid[$i][$j] eq "X" || $grid[$i][$j] eq "Y");
				$grid[$i][$j] = "X";
				last RUN if ($i == 0);
				$i--;
			}

			return ($i+1, $j);
		}

		if ($d == 1) {
			my $b = $j;
			$grid[$i][$b++] = "Y" while (!($grid[$i][$b] eq "#") && $b != scalar(@grid));

			while (!($grid[$i][$j] eq "#")) {
				$magic_cross_count++ if ($grid[$i][$j] eq "X" || $grid[$i][$j] eq "Y");
				$grid[$i][$j] = "X";
				last RUN if ($j == scalar(@grid)-1);
				$j++;
			}

			return ($i, $j-1);
		}

		if ($d == 3) {
			my $b = $j;
			$grid[$i][$b--] = "Y" while (!($grid[$i][$b] eq "#") && $b != -1);

			while (!($grid[$i][$j] eq "#")) {
				$magic_cross_count++ if ($grid[$i][$j] eq "X" || $grid[$i][$j] eq "Y");
				$grid[$i][$j] = "X";
				last RUN if ($j == 0);
				$j--;
			}

			return ($i, $j+1);
		}
	}

	return undef;
}
