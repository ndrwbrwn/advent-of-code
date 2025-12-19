use Data::Dumper qw/ Dumper /;

my @grid;
push @grid, [split('', $_)] while (<>);

my %plots;
foreach my $i (0 .. scalar(@grid)-1) {
	foreach my $j (0 .. scalar(@grid)-1) {
		 process_new($i,$j,$grid[$i][$j]);
	}
}

my ($c_one, $c_two);
for (values %plots) {
	if (ref($_) eq "ARRAY") {
		$c_one += @{$_}[1] * @{$_}[2];
		$c_two += @{$_}[1] * @{$_}[5];
	}
}

print "Part One\n";
print $c_one . "\n";
print "Part Two\n";
print $c_two . "\n";

sub process_new
{
	my ($i, $j, $l) = @_;

	my ($p, $pl);
	if ((defined ($p = find_real_plot($i-1,$j))) and (@{$p}[0] eq $l)) {
		if ((defined ($pl = find_real_plot($i,$j-1))) and (@{$pl}[0] eq $l)) {
			if ($p != $pl) {
				# there are distinct matching plots upwards and leftwards of here
				@{$p}[1] += @{$pl}[1] + 1;
				@{$p}[2] += @{$pl}[2];
				$plots{key(@{$pl}[3], @{$pl}[4])} = key(@{$p}[3], @{$p}[4]);
			} else {
				# there is one big plot upwards and leftwards of here
				@{$p}[1] += 1;
				@{$p}[2] += 0;
			}
		} else {
			# there is a matching plot upwards but not leftwards of here
			@{$p}[1] += 1;
			@{$p}[2] += 2;
		}
		$plots{key($i,$j)} = key(@{$p}[3],@{$p}[4]);
		return;
	} elsif ((defined ($p = find_real_plot($i,$j-1))) and (@{$p}[0] eq $l)) {
		# there is a matching plot leftwards, but not upwards of here
		@{$p}[1] += 1;
		@{$p}[2] += 2;
		$plots{key($i,$j)} = key(@{$p}[3], @{$p}[4]);
		return;
	}

	$plots{key($i,$j)} = [$l, 1, 4, $i, $j, 4];
}

sub find_real_plot
{
	my ($i, $j) = @_;

	my $s = ref($plots{key($i,$j)});
	if ($s eq "ARRAY") {
		return $plots{key($i,$j)};
	} else {
		my $l = $plots{key($i,$j)};

		return undef if (!defined $l);

		$l =~ /(\d+)\:(\d+)/;

		return find_real_plot($1+0, $2+0);
	}
}

sub key
{
	return sprintf "%d:%d", @_;
}
