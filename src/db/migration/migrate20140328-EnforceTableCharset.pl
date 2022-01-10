#!/usr/bin/perl
# 
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
# 

use strict;
use Migrate;

Migrate::verifySchemaVersion(101);
enforceCharset();
Migrate::updateSchemaVersion(101, 102);
exit(0);

sub enforceCharset()
{
  my @tables = ('mail_item_dumpster', 'revision_dumpster', 'appointment_dumpster');
  foreach my $group (Migrate::getMailboxGroups()) {
    foreach my $table (@tables) {
    my $sql;
    $sql = <<_EOF_;
delimiter //
create procedure convertCharset()
    BEGIN
    SET \@curCharset = 
    (SELECT CCSA.character_set_name FROM information_schema.tables T,
       information_schema.collation_character_set_applicability CCSA
    WHERE CCSA.collation_name = T.table_collation
    AND T.table_schema = "$group"
    AND T.table_name = "$table");
    IF \@curCharset!="utf8" 
    THEN 
        ALTER TABLE $group.$table
        CONVERT TO CHARACTER SET "utf8";
    END IF;
    END//
delimiter ;
call convertCharset();
drop procedure convertCharset;
_EOF_
 Migrate::runSql($sql);
}
}
}

