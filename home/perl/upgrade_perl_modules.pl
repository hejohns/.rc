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

I have been using this
when XS modules binary computability breaks
but maybe we should be using

    cpan recompile

instead?

=for comment
sentence doesn't really make sense but you get the point

=head1 AUTHOR

L<https://gist.github.com/degtyarev-dm/2896998>

pod mine (hejohns)

=cut
