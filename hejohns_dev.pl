#!/usr/bin/perl
use v5.28;

use warnings;
use strict;

use utf8;

# hardcoded
my $equivs_control_template = 'hejohns_dev.ctl';
my $SUB_FOR_DEPS = 'SUB_FOR_DEPS';
my $dep_list = 'hejohns_dev.txt';
my $updated_control_file = 'hejohns_dev';

# generate hejohns_dev
my $seen_SUB_FOR_DEPS = 0;
open(my $hejohns_dev_ctl_fh, '< :encoding(UTF-8)', $equivs_control_template)
    or die "equivs control file '$equivs_control_template' unable to be read: $!.";
open(my $hejohns_dev_txt_fh, '< :encoding(UTF-8)', $dep_list)
    or die "list of dependencies '$dep_list' unable to be read: $!.";
my $hejohns_dev; #store updated control file as string (it's short anyways...)
while(<$hejohns_dev_ctl_fh>){
    if(m/$SUB_FOR_DEPS/){
        chomp;
        if($seen_SUB_FOR_DEPS == 0){
            $seen_SUB_FOR_DEPS = 1;
        }
        else{
            die "'SUBS_FOR_DEPS must only' appear once.";
        }
        s/$SUB_FOR_DEPS//;
        $hejohns_dev .= $_;
        while(<$hejohns_dev_txt_fh>){
            chomp;
            $hejohns_dev .= "$_, ";
        }
        chop($hejohns_dev) eq ' ' or die 'malformed dep list.';
        chop($hejohns_dev) eq ',' or die 'malformed dep list.';
        $hejohns_dev .= "\n";
    }
    else{
        $hejohns_dev .= $_;
    }
}
if(-e $updated_control_file){
    say "'$updated_control_file' already exists. rm? y/n/c";
    chomp(my $ync = <STDIN>);
    if($ync eq 'y'){
        # goto proceed
    }
    else{
        die "aborting.";
    }
}
PROCEED:
open(my $hejohns_dev_fh, '> :encoding(UTF-8)', $updated_control_file)
    or die "unable to write to $updated_control_file: $!.";
print $hejohns_dev_fh $hejohns_dev;

# call equivs-build
!system "equivs-build $updated_control_file" or die "equivs probably isn't installed.";
