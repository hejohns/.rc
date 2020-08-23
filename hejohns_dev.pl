#!/usr/bin/perl
use v5.28;

use warnings;
use strict;

use utf8;

# hardcoded
my $equivs_control = 'hejohns_dev';
my $SUB_FOR_DEPS = 'SUB_FOR_DEPS';
my $dep_list = 'hejohns_dev.txt';

open(my $hejohns_dev_fh, '<', $equivs_control)
    or die "equivs control file \'$equivs_control\' unable to be read: $!";
open(my $hejohns_dev_txt_fh, '<', $dep_list)
    or die "list of dependencies \'$dep_list\' unable to be read: $!";
my $updated_hejohns_dev;
while(<$hejohns_dev_fh>){
    if(m/$SUB_FOR_DEPS/){
        chomp;
        s/$SUB_FOR_DEPS//;
        $updated_hejohns_dev = $updated_hejohns_dev . $_;
        while(<$hejohns_dev_txt_fh>){
            chomp;
            $updated_hejohns_dev .= "$_, ";
        }
        chop($updated_hejohns_dev) eq ' ' or die 'malformed dep list';
        chop($updated_hejohns_dev) eq ',' or die 'malformed dep list';
        $updated_hejohns_dev .= "\n";
    }
    else{
        $updated_hejohns_dev .= $_;
    }
}
print $updated_hejohns_dev;
