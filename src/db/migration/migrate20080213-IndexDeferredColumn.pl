#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(51);
addMailboxIndexDeferredCountColumn();
Migrate::updateSchemaVersion(51, 52);

exit(0);

#####################

sub addMailboxIndexDeferredCountColumn() {
  Migrate::log("Adding idx_deferred_count column to Mailbox table.");

  my $sql = <<ALTER_TABLE_EOF;
ALTER TABLE zimbra.mailbox ADD COLUMN idx_deferred_count INTEGER UNSIGNED NOT NULL DEFAULT 0;
ALTER_TABLE_EOF

  Migrate::runSql($sql);
}
