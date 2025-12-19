my @strep = ();
my @lirep = ();

while (<>) {
	my $id = 0;
	my $s = 0;

	foreach my $c (split('', $_)) {
		if (!$s) {
			push @lirep, [$id, $c];
			push @strep, $id foreach (1 .. ($c));
			$id++;
		} else {
			push @lirep, [".", $c];
			push @strep, "." foreach (1 .. ($c));
		}

		$s = 1 - $s;
	}
}

my $lj = 0;
FILE: foreach my $i (reverse (0 .. (scalar(@strep) - 1))) {
	next if ($strep[$i] eq ".");

	foreach my $j ($lj .. $i) {
		if ($strep[$j] eq ".") {
			$strep[$j] = $strep[$i];
			$strep[$i] = ".";
			$lj = $j;
			next FILE;
		}
	}
}

my $c = 0;
foreach my $i (0 .. scalar(@strep)) {
	last if ($strep[$i] eq ".");
	$c += $i * $strep[$i];
}

print "Part One\n";
print $c . "\n";

FILE: foreach my $i (reverse (0 .. (scalar(@lirep) - 1))) {
	next if ($lirep[$i][0] eq ".");

	foreach my $j (0 .. $i) {
		if ($lirep[$j][0] eq "." and $lirep[$i][1] < $lirep[$j][1]) {
			splice @lirep, $j, 1, [$lirep[$i][0], $lirep[$i][1]], [".", $lirep[$j][1] - $lirep[$i][1]];
			$i++; # we added an element - make sure we don't miss anything
			$lirep[$i][0] = ".";
			next FILE;
		}
		if ($lirep[$j][0] eq "." and $lirep[$i][1] == $lirep[$j][1]) {
			splice @lirep, $j, 1, [$lirep[$i][0], $lirep[$i][1]];
			$lirep[$i][0] = ".";
			next FILE;
		}
	}
}

my $base = 0;
$c = 0;
foreach my $i (0 .. (scalar(@lirep) - 1)) {
	foreach my $j (1 .. $lirep[$i][1]) {
		$c += $base * ($lirep[$i][0] eq "." ? 0 : $lirep[$i][0]);
		$base++;
	}
}

print "Part Two\n";
print $c . "\n";
