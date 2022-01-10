#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;
my $concurrent = 10;

Migrate::verifySchemaVersion(39);

my @sql = ();
my $sqlStmt = <<_SQL_;
ALTER TABLE mailbox
ADD COLUMN last_backup_at INTEGER UNSIGNED AFTER tracking_imap,
ADD INDEX i_last_backup_at (last_backup_at, id);
_SQL_
push(@sql, $sqlStmt);
Migrate::runSqlParallel($concurrent, @sql);

Migrate::updateSchemaVersion(39, 40);

exit(0);
