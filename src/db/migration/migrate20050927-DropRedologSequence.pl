#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 


use strict;
use Migrate;

Migrate::verifySchemaVersion(20);

dropRedoLogSequence();

Migrate::updateSchemaVersion(20, 21);

exit(0);

#####################

sub dropRedoLogSequence() {
    my $sql = "drop table if exists redolog_sequence;";
    Migrate::runSql($sql);
}
