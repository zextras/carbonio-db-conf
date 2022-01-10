#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(47);
Migrate::runSql("CREATE INDEX i_mailbox_id ON zimbra.scheduled_task (mailbox_id);");
Migrate::updateSchemaVersion(47, 48);
exit(0);
