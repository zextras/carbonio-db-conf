#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

Migrate::verifySchemaVersion(85);

addVersionColumn();

Migrate::updateSchemaVersion(85, 86);

exit(0);

#####################

sub addVersionColumn() {
    my $sql = <<MAILBOX_ADD_COLUMN_EOF;
ALTER TABLE mailbox ADD COLUMN version VARCHAR(16);
MAILBOX_ADD_COLUMN_EOF
    
    Migrate::log("Adding version column to ZIMBRA.MAILBOX table.");
    Migrate::runSql($sql);
}
