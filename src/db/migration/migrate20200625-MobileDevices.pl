#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#


use strict;
use Migrate;

Migrate::verifySchemaVersion(112);

addMobileOperatorColumn();

Migrate::updateSchemaVersion(112, 113);

exit(0);

#####################

sub addMobileOperatorColumn() {
    my $sql = <<MOBILE_DEVICES_ADD_COLUMN_EOF;
ALTER TABLE mobile_devices ADD COLUMN mobile_operator VARCHAR(512);
MOBILE_DEVICES_ADD_COLUMN_EOF

    Migrate::log("Adding mobile_operator column to ZIMBRA.MOBILE_DEVICES table.");
    Migrate::runSql($sql);
}
