#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 

use strict;
use Migrate;

addConfigColumn();
Migrate::updateSchemaVersion(13);

exit(0);

#####################

sub addConfigColumn() {
    my $sql = <<EOF;
ALTER TABLE liquid.mailbox
ADD COLUMN config TEXT AFTER tracking_sync;

EOF
    
    Migrate::log("Adding CONFIG column to liquid.mailbox.");
    Migrate::runSql($sql);
}
