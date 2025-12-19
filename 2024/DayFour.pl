my @rows;

push @rows, [split('', $_)] while (<>);

my $c_one, $c_two;
for my $i (0 .. scalar(@rows)) {
	for my $j (0 .. scalar(@rows)) {
		$c_one += xmas($i, $j) if ($rows[$i][$j] eq "X" || $rows[$i][$j] eq "S");

		next if ($i == 0 || $j == 0 || $i == scalar(@rows) || $j == scalar(@rows));
		$c_two += x_mas($i, $j) if ($rows[$i][$j] eq "A");
	}
}

print "Part One\n";
print $c_one . "\n";
print "Part Two\n";
print $c_two . "\n";

sub xmas
{
	my ($i, $j) = @_;
	my $w = "";
	my $c = 0;

	$w .= $rows[$i + $_][$j] foreach (0 .. 3);      # check south
	$c++ if ($w eq "XMAS" || $w eq "SAMX");

	$w = "";
	$w .= $rows[$i][$j + $_] foreach (0 .. 3);      # check east
	$c++ if ($w eq "XMAS" || $w eq "SAMX");

	$w = "";
	$w .= $rows[$i + $_][$j + $_] foreach (0 .. 3); # check southeast
	$c++ if ($w eq "XMAS" || $w eq "SAMX");

	$w = "";
	$w .= $rows[$i + $_][$j - $_] foreach (0 .. 3); # check southwest
	$c++ if ($w eq "XMAS" || $w eq "SAMX");

	return $c;
}

sub x_mas
{
	my ($i, $j) = @_;
	my $w = "";

	$w .= $rows[$i + $_][$j + $_] foreach (-1, 0, 1);
	$w .= $rows[$i + $_][$j - $_] foreach (-1, 0, 1);

	return scalar($w =~ /(MASMAS|MASSAM|SAMMAS|SAMSAM)/);
}
