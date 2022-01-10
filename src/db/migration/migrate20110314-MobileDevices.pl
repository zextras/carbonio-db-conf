#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(80);

addDeviceInformationColumns();

Migrate::updateSchemaVersion(80, 81);

exit(0);

#####################

sub addDeviceInformationColumns() {
    my $sql = <<MOBILE_DEVICES_ADD_COLUMN_EOF;
ALTER TABLE mobile_devices ADD COLUMN model VARCHAR(64);
ALTER TABLE mobile_devices ADD COLUMN imei VARCHAR(64);
ALTER TABLE mobile_devices ADD COLUMN friendly_name VARCHAR(512);
ALTER TABLE mobile_devices ADD COLUMN os VARCHAR(64);
ALTER TABLE mobile_devices ADD COLUMN os_language VARCHAR(64);
ALTER TABLE mobile_devices ADD COLUMN phone_number VARCHAR(64);
MOBILE_DEVICES_ADD_COLUMN_EOF
    
    Migrate::log("Adding device information columns to ZIMBRA.MOBILE_DEVICES table.");
    Migrate::runSql($sql);
}
