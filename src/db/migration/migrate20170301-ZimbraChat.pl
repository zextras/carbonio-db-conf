#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

Migrate::verifySchemaVersion(107);

my $sqlStmt = <<_SQL_;


CREATE DATABASE IF NOT EXISTS `chat`;

CREATE TABLE IF NOT EXISTS chat.`USER` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ADDRESS` varchar(256) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS chat.`RELATIONSHIP` (
  `USERID` int(11) NOT NULL,
  `TYPE` tinyint(4) NOT NULL,
  `BUDDYADDRESS` varchar(256) NOT NULL,
  `BUDDYNICKNAME` varchar(128) NOT NULL,
  `GROUP` varchar(256) NOT NULL DEFAULT ''
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS chat.`EVENTMESSAGE` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `USERID` int(11) NOT NULL,
  `EVENTID` varchar(36) DEFAULT NULL,
  `SENDER` varchar(256) NOT NULL,
  `TIMESTAMP` bigint(20) DEFAULT NULL,
  `MESSAGE` text,
  PRIMARY KEY (`ID`)
) ENGINE = InnoDB;
_SQL_

Migrate::runSql($sqlStmt);

Migrate::updateSchemaVersion(107, 108);

exit(0);