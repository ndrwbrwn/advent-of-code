my ($r_one, $r_two);
my $on = 1;

while (<>) {
	my @muls = ($_ =~ /(mul\(\d+,\d+\)|do(?:n't)?\(\))/g);

	foreach (@muls) {
		if ($_ =~ /mul\((\d+),(\d+)\)/) {
			$r_one += $1 * $2;
			$r_two += $1 * $2 if ($on);
		}

		$on = 1 if ($_ =~ /do\(\)/);
		$on = 0 if ($_ =~ /don't\(\)/);
	}
}

print "Part One\n";
print $r_one . "\n";
print "Part Two\n";
print $r_two . "\n";
