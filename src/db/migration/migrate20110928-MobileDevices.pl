#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(84);

addApplListColumns();

Migrate::updateSchemaVersion(84, 85);

exit(0);

#####################

sub addApplListColumns() {
    my $sql = <<MOBILE_DEVICES_ADD_COLUMN_EOF;
ALTER TABLE mobile_devices ADD COLUMN unapproved_appl_list TEXT NULL;
ALTER TABLE mobile_devices ADD COLUMN approved_appl_list TEXT NULL;
MOBILE_DEVICES_ADD_COLUMN_EOF
    
    Migrate::log("Adding unapproved_appl_list and approved_appl_list column to ZIMBRA.MOBILE_DEVICES table.");
    Migrate::runSql($sql);
}
