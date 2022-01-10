#!/usr/bin/perl

# SPDX-FileCopyrightText: 2021 Synacor, Inc.
# SPDX-FileCopyrightText: 2021 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-License-Identifier: GPL-2.0-only

use strict;
use lib "/opt/zextras/common/lib/perl5";
use Migrate;

Migrate::loadOutdatedMailboxes("2.2");
removeTagIndexes();

exit(0);

#####################

sub removeTagIndexes() {
  Migrate::log("dropping tag indexes");

  my @groups = Migrate::getMailboxGroups();
  foreach my $group (@groups) {
    # mboxgroup DBs created since the upgrade won't have the indexes, so test before dropping
    my $sql = <<CHECK_INDEXES_EOF;
SHOW INDEXES IN $group.mail_item WHERE Key_name = 'i_unread';
CHECK_INDEXES_EOF
    my @indexes = Migrate::runSql($sql);

    if (scalar(@indexes) > 0) {
      $sql = <<DROP_INDEXES_EOF;
ALTER TABLE $group.mail_item DROP INDEX i_unread, DROP INDEX i_tags_date, DROP INDEX i_flags_date;
DROP_INDEXES_EOF
      Migrate::runSql($sql);
    } else {
      Migrate::log("$group.MAIL_ITEM tag indexes already dropped");
    }

    $sql = <<CHECK_DUMPSTER_INDEXES_EOF;
SHOW INDEXES IN $group.mail_item_dumpster WHERE Key_name = 'i_unread';
CHECK_DUMPSTER_INDEXES_EOF
    @indexes = Migrate::runSql($sql);

    if (scalar(@indexes) > 0) {
      $sql = <<DROP_DUMPSTER_INDEXES_EOF;
ALTER TABLE $group.mail_item_dumpster DROP INDEX i_unread, DROP INDEX i_tags_date, DROP INDEX i_flags_date;
DROP_DUMPSTER_INDEXES_EOF
      Migrate::runSql($sql);
    } else {
      Migrate::log("$group.MAIL_ITEM_DUMPSTER tag indexes already dropped");
    }
  }
}
