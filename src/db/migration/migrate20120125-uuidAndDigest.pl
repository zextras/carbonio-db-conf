#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

sub doIt();

Migrate::verifySchemaVersion(86);
doIt();
Migrate::updateSchemaVersion(86, 87);

exit(0);

#####################

sub doIt() {
  Migrate::logSql("Adding uuid column and widening blob_digest column.");
  my @sqls;
  foreach my $group (Migrate::getMailboxGroups()) {
    my $sql;
    $sql = <<_EOF_;
ALTER TABLE $group.mail_item
  MODIFY COLUMN blob_digest VARCHAR(44) BINARY,
  ADD COLUMN uuid VARCHAR(127) AFTER mod_content,
  ADD INDEX i_uuid (mailbox_id, uuid);
_EOF_
    push(@sqls,$sql);

    $sql = <<_EOF_;
ALTER TABLE $group.mail_item_dumpster
  MODIFY COLUMN blob_digest VARCHAR(44) BINARY,
  ADD COLUMN uuid VARCHAR(127) AFTER mod_content,
  ADD INDEX i_uuid (mailbox_id, uuid);
_EOF_
    push(@sqls,$sql);

    $sql = <<_EOF_;
ALTER TABLE $group.revision
  MODIFY COLUMN blob_digest VARCHAR(44) BINARY;
_EOF_
    push(@sqls,$sql);

    $sql = <<_EOF_;
ALTER TABLE $group.revision_dumpster
  MODIFY COLUMN blob_digest VARCHAR(44) BINARY;
_EOF_
    push(@sqls,$sql);
  }

  my $concurrency = 10;
  Migrate::runSqlParallel($concurrency, @sqls);
}
