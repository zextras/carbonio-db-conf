#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(28);

my @groups = Migrate::getMailboxGroups();
my $sql = "";
foreach my $group (@groups) {
    $sql .= addTombstoneTypeColumn($group);
}

Migrate::runSql($sql);

Migrate::updateSchemaVersion(28, 29);

exit(0);

#####################

sub addTombstoneTypeColumn($) {
    my ($group) = @_;
    my $sql = <<ADD_TYPE_COLUMN_EOF;
ALTER TABLE $group.tombstone
ADD COLUMN type TINYINT AFTER date;

ADD_TYPE_COLUMN_EOF

    return $sql;
}
