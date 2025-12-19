my $c_one = 0;
my $c_two = 0;

while (<>) {
  chomp;
  my @ranges = ($_ =~ /([0-9\-]+)/g);

  foreach my $r (@ranges) {
    $r =~ /(\d+)-(\d+)/;
    for ($1..$2) {
      $c_one += $_ if ($_ =~ /^(\d+)\g{1}$/);
      $c_two += $_ if ($_ =~ /^(\d+)\g{1}+$/);
    }
  }
}

print "Part One\n$c_one\n";
print "Part Two\n$c_two\n";
