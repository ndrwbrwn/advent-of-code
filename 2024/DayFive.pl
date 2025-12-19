my %rules;
my ($c_one, $c_two);

LINE: while (<>) {
	if ($_ =~ /(\d+)\|(\d+)/) {
		push @{ $rules{$2} }, $1;
		next LINE;
	}

	if (my @pages = ($_ =~ /(\d+)/g)) {
		my @seen;

		PAGE: for my $i (0 .. scalar(@pages)) {
			foreach (@{ $rules{$pages[$i]} }) {
				my $needed = $_;

				next unless (grep {$_ == $needed} @pages);
				last PAGE unless (grep {$_ == $needed} @seen);
			}

			push @seen, $pages[$i];
		}

		# if we saw everything, it's good, otherwise, it's bad
		if (scalar(@seen)-1 == scalar(@pages)) {
			$c_one += $pages[scalar(@pages) / 2];
		} else {
			$c_two += sorted_midpoint(@pages);
		}
	}
}

print "Part One\n";
print $c_one . "\n";
print "Part Two\n";
print $c_two . "\n";

sub sorted_midpoint
{
	my (@input) = @_;

	my @re = sort {
		return -1 if (grep {$_ == $a} @{ $rules{$b} });
		return 1 if (grep {$_ == $b} @{ $rules{$a} });
		return 0;
	} @input;

	return $re[scalar(@re) / 2];
}
