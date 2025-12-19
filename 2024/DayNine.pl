my @strep = ();

while (<>) {
	my $id = 0;
	my $s = 0;

	foreach my $c (split('', $_)) {
		if (!$s) {
			push @strep, $id foreach (0 .. ($c-1));
			$id++;
		} else {
			push @strep, "." foreach (0 .. ($c-1));
		}

		$s = 1 - $s;
	}
}

my $lj = 0;
FILE: foreach my $i (reverse (0 .. (scalar(@strep) - 1))) {
	next if ($strep[$i] eq ".");

	FREE: foreach my $j ($lj .. $i) {
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
