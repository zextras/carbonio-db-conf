#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#


use strict;
use Migrate;

Migrate::verifySchemaVersion(106);

my $sqlDeleteStmt = <<_SQL_;
DROP TABLE IF EXISTS zmg_devices;
_SQL_

Migrate::runSql($sqlDeleteStmt);

my $sqlStmt = <<_SQL_;
CREATE TABLE IF NOT EXISTS zmg_devices (
   mailbox_id          INTEGER UNSIGNED NOT NULL,
   app_id              VARCHAR(64) NOT NULL,
   reg_id              VARCHAR(255) NOT NULL,
   push_provider       VARCHAR(8) NOT NULL,
   os_name             VARCHAR(16),
   os_version          VARCHAR(8),
   max_payload_size    INTEGER UNSIGNED,

   PRIMARY KEY (mailbox_id, app_id),
   CONSTRAINT uk_zmg_reg_id UNIQUE KEY (reg_id),
   CONSTRAINT fk_zmg_mailbox_id FOREIGN KEY (mailbox_id) REFERENCES mailbox(id) ON DELETE CASCADE,
   INDEX i_mailbox_id (mailbox_id),
   INDEX i_reg_id (reg_id)
) ENGINE = InnoDB;
_SQL_

Migrate::runSql($sqlStmt);

Migrate::updateSchemaVersion(106, 107);

exit(0);
