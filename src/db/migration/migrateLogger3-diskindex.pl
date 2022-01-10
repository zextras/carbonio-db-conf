#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;


Migrate::verifyLoggerSchemaVersion(2);

addIndices();

Migrate::updateLoggerSchemaVersion(2,3);

exit(0);

#####################

sub addIndices() {
    Migrate::log("Adding Indices");

	my $sql = <<EOF;
alter table disk_aggregate add index i_device (device);
alter table disk_aggregate add index i_host (host);
alter table disk_aggregate add index i_period_start (period_start);
alter table disk_aggregate add index i_period_end (period_end);
EOF

    Migrate::runLoggerSql($sql);
}
