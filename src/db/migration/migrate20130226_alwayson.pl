#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

########################################################################################################################

Migrate::verifySchemaVersion(92);

addItemcacheCheckpointColumn();
addCurrentSessionsTable();

Migrate::updateSchemaVersion(92, 100);

exit(0);

########################################################################################################################

sub addItemcacheCheckpointColumn() {
    Migrate::logSql("Adding ITEMCACHE_CHECKPOINT column to mailbox table...");
    my $sql = <<_EOF_;
ALTER TABLE mailbox ADD COLUMN itemcache_checkpoint INTEGER UNSIGNED NOT NULL DEFAULT 0;
_EOF_
  Migrate::runSql($sql);
}

sub addCurrentSessionsTable() {
    Migrate::logSql("Adding CURRENT_SESSIONS table...");
    my $sql = <<_EOF_;
CREATE TABLE IF NOT EXISTS current_sessions (
	id				INTEGER UNSIGNED NOT NULL,
	server_id		VARCHAR(127) NOT NULL,
	PRIMARY KEY (id, server_id)
) ENGINE = InnoDB;
_EOF_
  Migrate::runSql($sql);
}
