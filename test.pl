#!/usr/bin/env perl
use lib 'lib';
use Schema;
use Modern::Perl;
use Data::Dumper;

my $db = Schema->connect('dbi:SQLite:dbname=devnotes.db');

my $files = $db->resultset('File')->search({
    user_id   => 1,
    parent_id => undef,
});

my @output;
while ( my $file = $files->next ) {
	my %result;    
	$result{label} = $file->name;
	$result{id}    = $file->id;

	push @output, \%result and next if $file->is_leaf;

	# This has children, let's deal with them.
	traverse($file,\%result);
	push @output, \%result;
}

print Dumper \@output;

sub traverse {
  my $dbh = shift;
  my $result = shift;

  return if $dbh->is_leaf;

  my @children = $dbh->children;
  
  
  for my $child (@children) {
    my %child;
    $child{label} = $child->name;
    $child{id} = $child->id;
    push @{$result->{children}}, \%child;
    traverse($child,$result);
  }
}