#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(48);
Migrate::runSql("ALTER TABLE mailbox MODIFY COLUMN account_id VARCHAR(127) NOT NULL;");
Migrate::runSql("ALTER TABLE deleted_account MODIFY COLUMN account_id VARCHAR(127) NOT NULL;");
Migrate::updateSchemaVersion(48, 49);
exit(0);
