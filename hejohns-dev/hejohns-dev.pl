#!/usr/bin/perl
use v5.28;

use warnings;
use strict;

use utf8;

# hardcoded
my $package_name = 'hejohns-dev';
my $equivs_control_template = "$package_name.ctl";
my $SUB_FOR_DEPS = 'SUB_FOR_DEPS';
my $dep_list = "$package_name.txt";
my $updated_control_file = "$package_name.new.ctl";

# generate $package_name control file
my $output; #store updated control file as string (it's short anyways...)
my $seen_SUB_FOR_DEPS = 0;
open(my $ctl_fh, '< :encoding(UTF-8)', $equivs_control_template)
    or die "equivs control file '$equivs_control_template' unable to be read: $!.";
open(my $dep_txt_fh, '< :encoding(UTF-8)', $dep_list)
    or die "list of dependencies '$dep_list' unable to be read: $!.";
while(<$ctl_fh>){
    if(m/$SUB_FOR_DEPS/){
        chomp;
        if($seen_SUB_FOR_DEPS == 0){
            $seen_SUB_FOR_DEPS = 1;
        }
        else{
            die "'SUBS_FOR_DEPS must only' appear once.";
        }
        s/$SUB_FOR_DEPS//;
        $output .= $_;
        chomp(my @deps = <$dep_txt_fh>);
        $output .= join(', ', @deps) . "\n";
    }
    else{
        $output .= $_;
    }
}
if(-e $updated_control_file){
    say "'$updated_control_file' already exists. rm? y/n/c";
    chomp(my $ync = <STDIN>);
    if($ync eq 'y'){
        # goto PROCEED
    }
    else{
        die "aborting.";
    }
}
PROCEED:
open(my $output_fh, '> :encoding(UTF-8)', $updated_control_file)
    or die "unable to write to $updated_control_file: $!.";
print $output_fh $output;

# call equivs-build
!system "equivs-build $updated_control_file" or die "equivs probably isn't installed.";
