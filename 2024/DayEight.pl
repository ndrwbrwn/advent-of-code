my @grid;
my %antennae;

my $row = 0;
while (<>) {
	chomp;
	my $col = 0;
	push @grid, [split('', $_)];

	foreach my $c (split('', $_)) {
		push @{ $antennae{$c} }, [$row, $col] unless ($c eq ".");
		$col++;
	}
	$row++;
}

foreach my $a (keys %antennae) {
	my @pos = @{ $antennae{$a} };

	foreach my $i (0 .. (scalar(@pos)-1)) {
		foreach my $j (0 .. ($i-1)) {
			my $odx = $pos[$i][0] - $pos[$j][0];
			my $ody = $pos[$i][1] - $pos[$j][1];
			my $dx = $odx;
			my $dy = $ody;

			my $t = "%";

			while ($pos[$i][0]+$dx >= 0 and $pos[$i][1]+$dy >= 0 and $pos[$i][0]+$dx < scalar(@grid) and $pos[$i][1]+$dy < scalar(@grid)) {
				$grid[$pos[$i][0]+$dx][$pos[$i][1]+$dy] = $t if (!($grid[$pos[$i][0]+$dx][$pos[$i][1]+$dy] eq "%"));
				$dx += $odx;
				$dy += $ody;
				$t = "#";
			}
			
			$dx = $odx;
			$dy = $ody;
			$t = "%";

			while ($pos[$j][0]-$dx >= 0 and $pos[$j][1]-$dy >= 0 and $pos[$j][0]-$dx < scalar(@grid) and $pos[$j][1]-$dy < scalar(@grid)) {
				$grid[$pos[$j][0]-$dx][$pos[$j][1]-$dy] = $t if (!($grid[$pos[$j][0]-$dx][$pos[$j][1]-$dy] eq "%"));
				$dx += $odx;
				$dy += $ody;
				$t = "#";
			}
		}
	}
}

my ($c_one, $c_two);
foreach (@grid) {
	foreach my $c (@{$_}) {
		$c_one++ if ($c eq "%");
		$c_two++ if (!($c eq "."));
	}
}

print "Part One\n";
print $c_one++ . "\n";
print "Part Two\n";
print $c_two++ . "\n";
