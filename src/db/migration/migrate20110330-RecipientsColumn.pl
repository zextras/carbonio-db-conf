#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;
my $concurrent = 10;
########################################################################################################################

Migrate::verifySchemaVersion(81);

addRecipientsColumn();

Migrate::updateSchemaVersion(81, 82);

exit(0);

########################################################################################################################

sub addRecipientsColumn() {
  my @groups = Migrate::getMailboxGroups();
  my @sql = ();
  foreach my $group (@groups) {
    my $sql = <<_EOF_;
ALTER TABLE $group.mail_item ADD COLUMN recipients VARCHAR(128) AFTER sender;
_EOF_
    push(@sql,$sql);
  }
  Migrate::runSqlParallel($concurrent,@sql);

  @sql = ();
  foreach my $group (@groups) {
    my $sql = <<_EOF_;
ALTER TABLE $group.mail_item_dumpster ADD COLUMN recipients VARCHAR(128) AFTER sender;
_EOF_
    push(@sql,$sql);
  }
  Migrate::runSqlParallel($concurrent,@sql);
}
