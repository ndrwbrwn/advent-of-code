my ($c_one, $c_two, $c);

while (<>) {
	if (my @report = ($_ =~ /(\d+)/g)) {
		$c++;

		if (defined (my $i = find_error(@report))) {
			$c_one++;

			my @copy = @report;
			my @nofirst = @report;

			# three failure cases: index is wrong, index+1 is wrong,
			# or we mischaracterised the report as (in|de)creasing
			splice @report, $i, 1;
			splice @copy, $i+1, 1;
			splice @nofirst, 0, 1;

			$c_two++ if ((defined find_error(@report)) &&
				(defined find_error(@copy)) &&
				(defined find_error(@nofirst)));
		}
	}
}

print "Part One\n";
print "" . ($c - $c_one) . "\n";
print "Part Two\n";
print "" . ($c - $c_two) . "\n";

sub find_error
{
	my @input = @_;

	my $decrease = $input[0] > $input[1];

	for my $i (0 .. (scalar(@input) - 2)) {
		if (($decrease && ($input[$i] < $input[$i+1])) ||
			(!$decrease && ($input[$i] > $input[$i+1])) ||
			($input[$i] == $input[$i+1]) ||
			(abs($input[$i] - $input[$i+1]) > 3)) {
				return $i;
		}
	}

	return undef;
}
