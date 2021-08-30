#!/usr/bin/perl
use v5.28;
use utf8;

use warnings;
use strict;

use File::Basename;
use File::Copy;
use File::HomeDir;
use File::Spec;

sub filter_out_non_rcs{
    my @rcs_only;
    while (@_){
        my $file_to_consider = shift;
        if(substr ($file_to_consider, 0, 1) eq '.'){
            # kill . .. and any hidden files
            next;
        }
        elsif($file_to_consider eq basename ($0)){
            # also kill script name
            next;
        }
        else{
            push (@rcs_only, $file_to_consider);
        }
    }
    return @rcs_only;
}

opendir (my $cd_dh, dirname($0)) or die "Couldn't open rc file directory: $!";
my $home = File::HomeDir->my_home;
my @files_to_overwrite;
foreach (&filter_out_non_rcs (readdir $cd_dh)){
    my ($here, $there) = (File::Spec->catfile($home, '.' . $_),
        File::Spec->catfile(dirname($0), $_)
        );
    `diff $here $there`;
    if ($? == -1){
        die "diff not found. $!";
    }
    elsif ($? >> 8 == 0){
        next;
    }
    else{
        push (@files_to_overwrite, $_);
    }
}
if (@files_to_overwrite){
    say "Continue, overwriting:";
    foreach (@files_to_overwrite){
        say File::Spec->catfile($home, '.' . $_);
    }
    say "? y/n";
    chomp (my $yn = <STDIN>);
    unless ($yn eq 'y'){
        die("Aborting...\n");
    }
    foreach (@files_to_overwrite){
        copy (File::Spec->catfile(dirname($0), $_),
            File::Spec->catfile($home, '.' . $_)
        )
            or die "Failed to copy rc files over: $!";
    }
}
else{
    say "No modifications required";
}
# mutt stuff
my $mutt_home = File::Spec->catfile($home, ".mutt");
if (-e $mutt_home){
    if (-d $mutt_home){
        my $mutt_cache = File::Spec->catfile($mutt_home, "cache");
        my $mutt_header_cache = File::Spec->catfile($mutt_cache, "headers");
        my $mutt_body_cache = File::Spec->catfile($mutt_cache, "bodies");
        if (-e $mutt_cache){
            if (-d $mutt_cache){
                unless (-e $mutt_header_cache){
                    open(my $fh,
                        ">:encoding(UTF-8)",
                        $mutt_header_cache
                    )
                        or die "Failed to create mutt header cache: $!";
                }
                unless (-e $mutt_body_cache){
                    open(my $fh,
                        ">:encoding(UTF-8)",
                        $mutt_body_cache
                    )
                        or die "Failed to create mutt body cache: $!";
                }
            }
            else{
                die "~/.mutt/cache is not a directory: $!";
            }
        }
        else{
        }
    }
    else{
        die "~/.mutt not a directory: $!";
    }
}
else{
    die "~/.mutt does not exist: $!"
}
# bash completion
my $completions = '~/.nix-profile/share/bash-completion/completions';
if(-e  $completions && -d $completions){
    `rsync -av $completions ~/.bash_completion.d`;
    if($? == -1){
        die "rsync not found: $!";
    }
    elsif($? >> 8 != 0){
        die "some problem with rsync: $!";
    }
}
else{
    say "run: nix-env --install bash-completion";
}
