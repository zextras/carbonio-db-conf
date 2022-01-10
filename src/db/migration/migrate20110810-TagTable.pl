#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

########################################################################################################################

my $concurrent = 10;

Migrate::verifySchemaVersion(83);

my @groups = Migrate::getMailboxGroups();

addTagTable();
addTaggedItemTable();
addTagNamesColumn();

#  See migrate20140624-DropMysqlIndexes.pl for dropping of tag related indexes in Zimbra 8.5

Migrate::updateSchemaVersion(83, 84);

exit(0);

########################################################################################################################

sub addTagTable() {
  my @sql = ();
  foreach my $group (@groups) {
    Migrate::logSql("Adding $group.TAG table...");
    my $sql = <<_EOF_;
CREATE TABLE IF NOT EXISTS $group.tag (
   mailbox_id    INTEGER UNSIGNED NOT NULL,
   id            INTEGER NOT NULL,
   name          VARCHAR(128) NOT NULL,
   color         BIGINT,
   item_count    INTEGER NOT NULL DEFAULT 0,
   unread        INTEGER NOT NULL DEFAULT 0,
   listed        BOOLEAN NOT NULL DEFAULT FALSE,
   sequence      INTEGER UNSIGNED NOT NULL,  -- change number for rename/recolor/etc.
   policy        VARCHAR(1024),

   PRIMARY KEY (mailbox_id, id),
   UNIQUE INDEX i_tag_name (mailbox_id, name),
   CONSTRAINT fk_tag_mailbox_id FOREIGN KEY (mailbox_id) REFERENCES zimbra.mailbox(id)
) ENGINE = InnoDB;
_EOF_
    push(@sql,$sql);
  }
  Migrate::runSqlParallel($concurrent,@sql);
}

sub addTaggedItemTable() {
  my @sql = ();
  foreach my $group (@groups) {
    Migrate::logSql("Adding $group.TAGGED_ITEM table...");
    my $sql = <<_EOF_;
CREATE TABLE IF NOT EXISTS $group.tagged_item (
   mailbox_id    INTEGER UNSIGNED NOT NULL,
   tag_id        INTEGER NOT NULL,
   item_id       INTEGER UNSIGNED NOT NULL,

   UNIQUE INDEX i_tagged_item_unique (mailbox_id, tag_id, item_id),
   CONSTRAINT fk_tagged_item_tag FOREIGN KEY (mailbox_id, tag_id) REFERENCES $group.tag(mailbox_id, id) ON DELETE CASCADE,
   CONSTRAINT fk_tagged_item_item FOREIGN KEY (mailbox_id, item_id) REFERENCES $group.mail_item(mailbox_id, id) ON DELETE CASCADE
) ENGINE = InnoDB;
_EOF_
    push(@sql,$sql);
  }
  Migrate::runSqlParallel($concurrent,@sql);
}

sub addTagNamesColumn() {
  my @sql = ();
  foreach my $group (@groups) {
    Migrate::logSql("Adding TAG_NAMES column to $group.MAIL_ITEM and $group.MAIL_ITEM_DUMPSTER...");
    my $sql = <<_EOF_;
ALTER TABLE $group.mail_item ADD COLUMN tag_names TEXT AFTER tags;
_EOF_
    push(@sql,$sql);
  }
  foreach my $group (@groups) {
    Migrate::logSql("Adding TAG_NAMES column to $group.MAIL_ITEM and $group.MAIL_ITEM_DUMPSTER...");
    my $sql = <<_EOF_;
ALTER TABLE $group.mail_item_dumpster ADD COLUMN tag_names TEXT AFTER tags;
_EOF_
    push(@sql,$sql);
  }
  Migrate::runSqlParallel($concurrent,@sql);
}
