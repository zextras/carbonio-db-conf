#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;


Migrate::verifyLoggerSchemaVersion(3);

addLogHostName();

Migrate::updateLoggerSchemaVersion(3,4);

exit(0);

#####################

sub addLogHostName() {
    Migrate::log("Adding loghostname");

	my $sql = <<EOF;
alter table service_status add column loghostname VARCHAR(255) NOT NULL;
EOF

    Migrate::runLoggerSql($sql);
}
