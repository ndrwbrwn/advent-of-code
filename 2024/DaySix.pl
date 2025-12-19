my (@grid, @pc);
my ($starti, $startj);

SETUP: {
	push @grid, [split('', $_)] while (<>);

	my ($i, $j);
	SEARCH: for ($i = 0; $i < scalar(@grid); $i++) {
		for ($j = 0; $j < scalar(@grid); $j++) {
			last SEARCH if ($grid[$i][$j] eq "^");
		}
	}

	($starti, $startj) = ($i, $j);
}

PART_ONE: {
	my ($i, $j, $d) = ($starti, $startj, 0);
	my @v;

	while (@v = movedir($i, $j, $d)) {
		$d = ($d + 1) % 4;
		($i, $j) = @v;

		last if ((!defined $i) || (!defined $j));
	}

	for ($i = 0; $i < scalar(@grid); $i++) {
		for ($j = 0; $j < scalar(@grid); $j++) {
			push @pc, [($i,$j)] if ($grid[$i][$j] eq "X");
		}
	}

	print "Part One\n";
	print scalar(@pc) . "\n";
}

PART_TWO: {
	my ($loops, $i, $j, $d) = (0, 0, 0, 0);

	foreach my $o (@pc) {
		my $sq = $grid[@{$o}[0]][@{$o}[1]];
		$grid[@{$o}[0]][@{$o}[1]] = "#";

		my (@turns, @v);
		($i, $j, $d) = ($starti, $startj, 0);

		while (@v = movedir($i, $j, $d)) {
			$d = ($d + 1) % 4;
			($i, $j) = @v;

			last if ((!defined $i) || (!defined $j));

			if (grep { @{$_}[0] == $d and @{$_}[1] == $i and @{$_}[2] == $j } @turns) {
				$loops++;
				last;
			}

			push @turns, [($d, $i, $j)];
		}

		$grid[@{$o}[0]][@{$o}[1]] = $sq;
	}

	print "Part Two\n";
	print $loops . "\n";
}

sub movedir
{
	my ($i, $j, $d) = @_;

	RUN: {
		if ($d == 2) {
			while (!($grid[$i][$j] eq "#")) {
				$grid[$i][$j] = "X";
				last RUN if ($i == scalar(@grid)-1);
				$i++;
			}
			return ($i-1, $j);
		}

		if ($d == 0) {
			while (!($grid[$i][$j] eq "#")) {
				$grid[$i][$j] = "X";
				last RUN if ($i == 0);
				$i--;
			}

			return ($i+1, $j);
		}

		if ($d == 1) {
			while (!($grid[$i][$j] eq "#")) {
				$grid[$i][$j] = "X";
				last RUN if ($j == scalar(@grid)-1);
				$j++;
			}

			return ($i, $j-1);
		}

		if ($d == 3) {
			while (!($grid[$i][$j] eq "#")) {
				$grid[$i][$j] = "X";
				last RUN if ($j == 0);
				$j--;
			}

			return ($i, $j+1);
		}
	}

	return undef;
}
