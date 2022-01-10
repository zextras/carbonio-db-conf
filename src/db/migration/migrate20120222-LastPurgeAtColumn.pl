#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

Migrate::verifySchemaVersion(87);

addLastPurgeAtColumn();

Migrate::updateSchemaVersion(87, 88);

exit(0);

#####################

sub addLastPurgeAtColumn() {
    my $sql = <<MAILBOX_ADD_COLUMN_EOF;
ALTER TABLE mailbox ADD COLUMN last_purge_at INTEGER UNSIGNED NOT NULL DEFAULT 0;
MAILBOX_ADD_COLUMN_EOF
    
    Migrate::log("Adding last_purge_at column to ZIMBRA.MAILBOX table.");
    Migrate::runSql($sql);
}