#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(65);

addLastUsedDateColumn();

Migrate::updateSchemaVersion(65, 80);

exit(0);

#####################

sub addLastUsedDateColumn() {
    my $sql = <<MOBILE_DEVICES_ADD_COLUMN_EOF;
ALTER TABLE mobile_devices ADD COLUMN last_used_date DATE;
ALTER TABLE mobile_devices ADD COLUMN deleted_by_user BOOLEAN NOT NULL DEFAULT 0 AFTER last_used_date;
ALTER TABLE mobile_devices ADD INDEX i_last_used_date (last_used_date);
MOBILE_DEVICES_ADD_COLUMN_EOF
    
    Migrate::log("Adding last_used_date and deleted_by_user column to ZIMBRA.MOBILE_DEVICES table.");
    Migrate::runSql($sql);
}
