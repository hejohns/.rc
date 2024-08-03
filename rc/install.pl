#!/usr/bin/perl
use v5.32;
use utf8;

use warnings;
use strict;

use File::Basename;
use File::Copy;
use File::Spec;

$SIG{INT} = sub{die "Aborting...\n"};

opendir (my $cd_dh, dirname($0)) or die "Couldn't open rc file directory: $!";
my $home = $ENV{HOME} // die "$!";
chomp $home;

my @upstream_rel = `find . -type f ! -name '.*' ! -name '${\(basename($0))}'`;
chomp @upstream_rel;
my @downstream_rel = map {'./.' . substr $_, 2} @upstream_rel;
my @zipped = map {($upstream_rel[$_] , $downstream_rel[$_])} (0 .. $#upstream_rel);
my @zipped_diff;
while (@zipped){
    my $upstream_rel = shift @zipped;
    my $downstream_rel = shift @zipped;
    my $upstream_abs = File::Spec->catfile(dirname($0), $upstream_rel);
    my $downstream_abs = File::Spec->catfile($home, $downstream_rel);
    `diff $upstream_abs $downstream_abs`;
    if($? == -1){
        die "diff not found. $!";
    }
    elsif($? >> 8 == 0){
        next;
    }
    else{
        push @zipped_diff, $upstream_abs, $downstream_abs;
    }
}
say "No modifications required" if !@zipped_diff;
while (@zipped_diff){
    my $upstream_abs = shift @zipped_diff;
    my $downstream_abs = shift @zipped_diff;
    print "overwrite: ";
    print $downstream_abs;
    RETRY:
    say "? y/n/d(iff)/(pu)s(h)/(u)p(load diff)";
    my $yn = <STDIN> // die "eof on stdin: $!";;
    chomp($yn);
    if($yn eq 'y'){
        say $upstream_abs, $downstream_abs;
        #copy($upstream_abs, $downstream_abs) or die "Failed to copy $_ : $!";
    }
    elsif($yn eq 'n'){
        say "skipping...";
        next;
    }
    elsif($yn eq 'd'){
        say '################################################################################';
        # this order makes more intuitive sense when reading the program output
        print `diff -NU 5 $downstream_abs $upstream_abs`;
        say '################################################################################';
    }
    elsif($yn eq 's'){
        say $downstream_abs, $upstream_abs;
        #copy($downstream_abs, $upstream_abs) or die "Failed to copy $_ : $!";
    }
    elsif($yn eq 'p'){
        say '################################################################################';
        print `diff -NU 5 $upstream_abs $downstream_abs`;
        say '################################################################################';
    }
    goto RETRY;
}

say '$ git add -u';
system 'git', 'add', '-u';
say '$ git status';
system 'git', 'status';
say '$ git diff --staged';
system 'git', 'diff', '--staged';
say 'commit changes? y/n';
my $yn = <STDIN> // die "eof on stdin: $!";
chomp($yn);
if($yn eq 'y'){
    system 'git', 'commit';
    say 'push changes? y/n';
    $yn = <STDIN> // die "eof on stdin: $!";
    chomp($yn);
    if($yn eq 'y'){
        system 'git', 'push';
    }
}
exit 0;

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
    say "~/.mutt does not exist: $!"
}

# bash completion
my $completions = $home . '.nix-profile/share/bash-completion/completions';
if(-e $completions && -d $completions){
    `rsync -av $completions/ ~/.bash_completion.d/`;
    if($? == -1){
        die "rsync not found: $!";
    }
    elsif($? >> 8 != 0){
        die "some problem with rsync: $!";
    }
}
else{
    die "run: nix-env --install bash-completion: $!";
}
