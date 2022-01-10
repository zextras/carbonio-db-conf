#!/usr/bin/perl

# SPDX-FileCopyrightText: 2021 Synacor, Inc.
# SPDX-FileCopyrightText: 2021 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-License-Identifier: GPL-2.0-only

use strict;
use Migrate;

Migrate::verifySchemaVersion(109);

my $sqlStmt = <<_SQL_;


ALTER TABLE chat.`USER` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE chat.`RELATIONSHIP` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE chat.`EVENTMESSAGE` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

_SQL_

Migrate::runSql($sqlStmt);

Migrate::updateSchemaVersion(109, 110);

exit(0);