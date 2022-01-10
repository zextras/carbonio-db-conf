#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

########################################################################################################################

Migrate::verifySchemaVersion(100);

foreach my $group (Migrate::getMailboxGroups()) {
    Migrate::log("Migrating $group.  This can take a substantial amount of time...");
    addPrevFoldersColumnToMailItem($group);
    addPrevFoldersColumnToMailItemDumpster($group);
    Migrate::log("done.\n");
}

Migrate::updateSchemaVersion(100, 101);

exit(0);

########################################################################################################################

sub addPrevFoldersColumnToMailItem($) {
    my ($group) = @_;
    Migrate::logSql("Adding prev_folder_ids column to mail_item table...");
    my $sql = <<_EOF_;
ALTER TABLE $group.mail_item ADD COLUMN prev_folders TEXT AFTER folder_id;
_EOF_
  Migrate::runSql($sql);
}

sub addPrevFoldersColumnToMailItemDumpster($) {
    my ($group) = @_;
    Migrate::logSql("Adding prev_folder_ids column to mail_item_dumpster table...");
    my $sql = <<_EOF_;
ALTER TABLE $group.mail_item_dumpster ADD COLUMN prev_folders TEXT AFTER folder_id;
_EOF_
  Migrate::runSql($sql);
}
