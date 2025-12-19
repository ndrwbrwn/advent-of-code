my $idx = 50;
my $c_one = 0;
my $c_two = 0;

while (<>) {
  chomp;
  $_ =~ /^(L|R)(\d+)/;

  for (1..$2) {
    $idx += ($1 eq "L" ? -1 : 1);

    $idx = 0 if ($idx == 100);
    $c_two++ if ($idx == 0);
    $idx = 99 if ($idx == -1);
  }
  $c_one++ if ($idx == 0);
}

print "Part One\n$c_one\n";
print "Part One\n$c_two\n";
