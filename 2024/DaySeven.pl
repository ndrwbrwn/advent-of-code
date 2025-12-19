my ($c_one, $c_two);

while (<>) {
	last unless ($_ =~ /(\d+): (.*)/);
	my $result = $1;
	my @inputs = ($2 =~ /(\d+)/g);

	my @outputs_1 = shift @inputs;
	my @outputs_2 = @outputs_1;
	for my $i (@inputs) {
		my @new_1;
		my @new_2;

		for my $j (@outputs_1) {
			push @new_1, ($j + $i);
			push @new_1, ($j * $i);
		}

		for my $j (@outputs_2) {
			push @new_2, ($j + $i);
			push @new_2, ($j * $i);
			push @new_2, ($j . $i);
		}

		@outputs_1 = @new_1;
		@outputs_2 = @new_2;
	}

	$c_one += $result if (grep {$_ == $result} @outputs_1);
	$c_two += $result if (grep {$_ == $result} @outputs_2);
}

print "Part One\n";
print $c_one . "\n";
print "Part Two\n";
print $c_two . "\n";
