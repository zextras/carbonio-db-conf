#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#


use strict;
use Migrate;

Migrate::verifySchemaVersion(113);

addLastUpdatedByColumn();

Migrate::updateSchemaVersion(113, 114);

exit(0);

#####################

sub addLastUpdatedByColumn() {
    my $sql = <<MOBILE_DEVICES_ADD_COLUMN_EOF;
ALTER TABLE mobile_devices ADD COLUMN last_updated_by ENUM('Admin','User') DEFAULT 'User';
MOBILE_DEVICES_ADD_COLUMN_EOF

    Migrate::log("Adding last_updated_by column to ZIMBRA.MOBILE_DEVICES table.");
    Migrate::runSql($sql);
}