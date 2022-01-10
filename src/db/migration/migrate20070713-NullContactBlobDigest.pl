#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;
my $concurrent = 10;

my @groups = Migrate::getMailboxGroups();

my @sql = ();
foreach my $group (@groups) {
    my $sql = <<_SQL_;
UPDATE $group.mail_item
SET blob_digest = NULL
WHERE type = 6
AND blob_digest = '';
_SQL_
    push(@sql, $sql);
}

Migrate::runSqlParallel($concurrent, @sql);

exit(0);
