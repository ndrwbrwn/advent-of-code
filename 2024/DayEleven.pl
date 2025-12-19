use List::Util qw/ sum /;

my @stones;
push @stones, ($_ =~ /(\d+)/g) while (<>);

my %cache;
my ($c_one, $c_two);
foreach (@stones) {
	$c_one += stonetree($_, 25);
	$c_two += stonetree($_, 75);
}

print "Part One\n";
print $c_one . "\n";
print "Part Two\n";
print $c_two . "\n";

sub stonetree
{
	my ($s, $t) = @_;

	return 1 if ($t == 0);
	return $cache{key($s,$t)} if (defined $cache{key($s,$t)});

	my $next = sum map { stonetree($_, $t-1) } blink($s);
	$cache{key($s,$t)} = $next;
	return $next;
}

sub key
{
	return sprintf "%d:%d", @_;
}

sub blink
{
	my ($s) = @_;

	if ($s + 0 == 0) {
		return 1;
	} elsif (!(length($s) % 2)) {
		my $s1 = substr $s, 0, length($s)/2;
		my $s2 = substr $s, length($s)/2;
		return ($s1 + 0, $s2 + 0);
	} else {
		return $s * 2024;
	}
}
