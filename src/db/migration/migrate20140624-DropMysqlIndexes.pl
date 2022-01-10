#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

########################################################################################################################

my $concurrent = 10;

Migrate::verifySchemaVersion(102);

my @groups = Migrate::getMailboxGroups();
#
&dropIndexes();

Migrate::updateSchemaVersion(102, 103);

exit(0);

########################################################################################################################

sub addSqlCommandsForDropIndexesForTable() {
  my ($tableName, $indexes, $mygroups, $sqlCommands) = @_;
  my @keyNames = ();
  foreach my $index (@{$indexes}) {
      push(@keyNames, "Key_name='$index'");
  }
  my $whereClause = join(' or ', @keyNames);
  foreach my $group (@{$mygroups}) {
    my @dropCmds = ();
    my @showIndexes = (Migrate::runSql("SHOW INDEX from $group.$tableName WHERE $whereClause;"));
    foreach my $index (@{$indexes}) {
      foreach my $showLine (@showIndexes) {
        my ($Table, $Non_Unique, $Key_name, @rest) = split('\s+', $showLine);
        if ($index eq $Key_name) {
          push(@dropCmds, "DROP INDEX $index");
          last;
        }
      }
    }
    my $allDrops = join(', ', @dropCmds);
    if (length $allDrops > 0) {
        my $sqlCommand = <<_EOF_;
ALTER TABLE $group.$tableName $allDrops;
_EOF_
        push(@{$sqlCommands},$sqlCommand);
    }
  }
}

########################################################################################################################
sub dropIndexes() {
  my @sql = ();

  my @indexes = ('i_unread', 'i_flags_date', 'i_tags_date', 'i_volume_id');
  &addSqlCommandsForDropIndexesForTable('mail_item', \@indexes, \@groups, \@sql);
  # same indexes need to be dropped for mail_item_dumpster as for mail_item
  &addSqlCommandsForDropIndexesForTable('mail_item_dumpster', \@indexes, \@groups, \@sql);

  Migrate::runSqlParallel($concurrent,@sql);
}
