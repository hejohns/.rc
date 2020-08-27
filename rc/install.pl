#!/usr/bin/perl
use v5.28;

use warnings;
use strict;

use utf8;
use File::Basename;
use File::Copy;
use File::HomeDir;
use File::Spec;

sub filter_out_non_rcs{
    my @rcs_only;
    while(@_){
        my $file_to_consider = shift;
        if(substr($file_to_consider, 0, 1) eq '.'){
            # kill . .. and any hidden files
            next;
        }
        elsif($file_to_consider eq basename($0)){
            # also kill script name
            next;
        }
        else{
            push(@rcs_only, ($file_to_consider));
        }
    }
    return @rcs_only;
}

opendir(my $cd_dh, dirname($0)) or die "Couldn't open rc file directory: $!";
my $home = File::HomeDir->my_home;
say "Continue, potentially overwriting existing .rc files in $home? y/n";
my $yn = <STDIN>;
if($yn eq 'y'){
    # continue;
}
else{
    die("Aborting...\n");
}
foreach(&filter_out_non_rcs(readdir($cd_dh))){
    copy(File::Spec->catfile(dirname($0), $_),
        File::Spec->catfile($home, '.' . $_));
}
say "Installed rc files to $home.";
