#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(63);

addPolicyValuesColumn();

Migrate::updateSchemaVersion(63, 64);

exit(0);

#####################

sub addPolicyValuesColumn() {
    my $sql = <<MOBILE_DEVICES_ADD_COLUMN_EOF;
ALTER TABLE mobile_devices ADD COLUMN policy_values VARCHAR(512);
MOBILE_DEVICES_ADD_COLUMN_EOF
    
    Migrate::log("Adding policy_values column to ZIMBRA.MOBILE_DEVICES table.");
    Migrate::runSql($sql);
}
