my $c_one = 0;
my $c_two = 0;

LINE: while (<>) {
  chomp;
  my @line = split('', $_);
  last LINE if (scalar(@line) == 0);

  my $jolt, $rangefrom = 0;
  for (my $i = 1; $i >= 0; $i--) {
    my ($idx, $max) = next_max_in_range($rangefrom, scalar(@line)-$i-1, @line);
    $jolt .= $max;
    $rangefrom = $idx+1;
  }
  $c_one += $jolt;

  $jolt = '';
  $rangefrom = 0;
  for (my $i = 11; $i >= 0; $i--) {
    my ($idx, $max) = next_max_in_range($rangefrom, scalar(@line)-$i-1, @line);
    $jolt .= $max;
    $rangefrom = $idx+1;
  }
  $c_two += $jolt;
}

sub next_max_in_range() {
  my $min = shift;
  my $max = shift;

  my $val = 0;
  my $idx = -1;
  CHECK: while (my ($i, $v) = each @_) {
    next CHECK if ($i < $min || $i > $max);
    if ($v > $val) {
      $idx = $i;
      $val = $v;
    }
  }

  return ($idx, $val);
}

print "Part One\n$c_one\n";
print "Part Two\n$c_two\n";
