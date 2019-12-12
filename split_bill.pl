#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use List::Util qw(sum);

# Args: -t=tip name dollars name dollars ...
my $tip = .18;
my $tax = .095;
my $verbose = '';
GetOptions(
  "t|tip=i" => \$tip,
  "x|tax=i" => \$tax,
  "v|verbose" => \$verbose
) or die 'error in cmd line args';

die "Must have even number of arguments (<name> <dish price>)\n" unless (scalar @ARGV) % 2 == 0;
die "Please supply at least one diner\n" unless (scalar @ARGV) > 0;

my %diners = ();
while (scalar @ARGV) {
  my $name = shift @ARGV;
  my $money = shift @ARGV;

  die "Invalid money format ($money)" unless $money =~ /^\$?(\d+(?:\.\d{2})?$)/;
  $money = $1;
  $diners{$name} = $money;
}

my $total_price = sum values %diners;
my $total_tax = $total_price * $tax;
my $total_tip = $total_price * $tip;

for my $diner (keys %diners) {
  my $dish_price = $diners{$diner};
  my $percentage_of_total_price = $dish_price / $total_price;
  my $tax_owed = $total_tax * $percentage_of_total_price;
  my $tip_owed = $total_tip * $percentage_of_total_price;

  my $owes = $dish_price + $tip_owed + $tax_owed;

  $owes = sprintf("%.2f", $owes);
  $percentage_of_total_price = sprintf("%.3f", $percentage_of_total_price) * 100;
  $tax_owed = sprintf("%.2f", $tax_owed);
  $tip_owed = sprintf("%.2f", $tip_owed);

  print "$diner owes \$$owes\n";
  if ($verbose) {
    print "\tBreakdown:\n";
    print "\t - Meal price: \$$dish_price\n";
    print "\t - Percentage of meal subtotal: $percentage_of_total_price %\n";
    print "\t - Tax owed: \$$tax_owed = (\$$total_tax * $percentage_of_total_price%)\n";
    print "\t - Tip owed: \$$tip_owed = (\$$total_tip * $percentage_of_total_price%)\n";
  } 
}