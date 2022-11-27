#!/usr/bin/env perl
use strict;
use File::Find;
my @modules=();
my %hash=();
find(\&wanted,@INC);
sub wanted
{
    push @modules, $1    if ($File::Find::name =~ /.*?auto\/([A-Z]([\w\d_\/]+)?)\/[\w\d_]+\.so$/);
}
my @uniq=grep{!$hash{$_}++} @modules;
for my $module (sort @uniq)
{
    $module =~s/\//\:\:/g;
    system("cpanm --reinstall ".$module);
}
print "[finish]";

=pod

=encoding utf8

=head1 NAME

upgrade_perl_modules.pl

=head1 DESCRIPTION

original description:

    Reinstall all perl XS-modules, for example after upgrade perl version(App::cpanminus need).

There has to be a proper way to do this,
but I've had to use this script over and over
so I can actually get work done,
so I'm copying it here now.

=head1 AUTHOR

L<https://gist.github.com/degtyarev-dm/2896998>

pod mine (hejohns)

=cut
