#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

Migrate::verifySchemaVersion(111);
foreach my $group (Migrate::getMailboxGroups()) {
    addWatchEventTables($group);
}
Migrate::updateSchemaVersion(111, 112);
exit(0);

sub addWatchEventTables($) {
  my ($DATABASE_NAME) = @_;   
  Migrate::logSql("Adding Event & Watch table to $DATABASE_NAME.");
  
my $sqlStmt = <<_SQL_;
CREATE TABLE IF NOT EXISTS ${DATABASE_NAME}.event (
   mailbox_id    INTEGER UNSIGNED NOT NULL,
   account_id    VARCHAR(36) NOT NULL,
   item_id       INTEGER NOT NULL,
   folder_id     INTEGER NOT NULL,
   op            TINYINT NOT NULL,
   ts            INTEGER NOT NULL,
   version       INTEGER,
   user_agent    VARCHAR(128),
   arg           VARCHAR(10240),

   CONSTRAINT fk_event_mailbox_id FOREIGN KEY (mailbox_id) REFERENCES zimbra.mailbox(id) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ${DATABASE_NAME}.watch (
   mailbox_id   INTEGER UNSIGNED NOT NULL,
   target       VARCHAR(36) NOT NULL,
   item_id      INTEGER NOT NULL,

   PRIMARY KEY (mailbox_id, target, item_id)
) ENGINE = InnoDB;
_SQL_

Migrate::runSql($sqlStmt);
}