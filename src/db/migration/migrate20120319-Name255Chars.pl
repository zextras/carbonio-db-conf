#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

sub doIt();

Migrate::verifySchemaVersion(89);
doIt();
Migrate::updateSchemaVersion(89, 90);

exit(0);

#####################

sub doIt() {
  Migrate::logSql("Expanding name column to 255 chars");
  my @sqls;
  foreach my $group (Migrate::getMailboxGroups()) {
    my $sql;
    $sql = <<_EOF_;
ALTER TABLE $group.mail_item
  MODIFY COLUMN name VARCHAR(255);
_EOF_
    push(@sqls,$sql);

    $sql = <<_EOF_;
ALTER TABLE $group.mail_item_dumpster
  MODIFY COLUMN name VARCHAR(255);
_EOF_
    push(@sqls,$sql);

    $sql = <<_EOF_;
ALTER TABLE $group.revision
  MODIFY COLUMN name VARCHAR(255);
_EOF_
    push(@sqls,$sql);

    $sql = <<_EOF_;
ALTER TABLE $group.revision_dumpster
  MODIFY COLUMN name VARCHAR(255);
_EOF_
    push(@sqls,$sql);
  }

  my $concurrency = 10;
  Migrate::runSqlParallel($concurrency, @sqls);
}
