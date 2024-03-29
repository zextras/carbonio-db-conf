#!/usr/bin/perl

# SPDX-FileCopyrightText: 2021 Synacor, Inc.
# SPDX-FileCopyrightText: 2021 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: GPL-2.0-only
# SPDX-License-Identifier: GPL-2.0-only

use strict;
use Migrate;

Migrate::verifySchemaVersion(108);

my $sqlStmt = <<_SQL_;

ALTER DATABASE chat DEFAULT CHARACTER SET utf8;

CREATE DATABASE IF NOT EXISTS `chat`
DEFAULT CHARACTER SET utf8;

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

CREATE TABLE IF NOT EXISTS chat.`MESSAGE` (
   `ID`             VARCHAR(48)   NOT NULL,
   `SENT_TIMESTAMP` BIGINT        NOT NULL,
   `EDIT_TIMESTAMP` BIGINT        DEFAULT 0,
   `MESSAGE_TYPE`   TINYINT       DEFAULT 0,
   `TARGET_TYPE`    TINYINT       DEFAULT 0,
   `INDEX_STATUS`   TINYINT       DEFAULT 0,
   `SENDER`         VARCHAR(256) NOT NULL,
   `DESTINATION`    VARCHAR(256) NOT NULL,
   `TEXT`           VARCHAR(4096),
   `REACTIONS`      VARCHAR(4096),
   `TYPE_EXTRAINFO` VARCHAR(4096)
) ENGINE = InnoDB;

CREATE INDEX IF NOT EXISTS INDEX_SENT
   ON chat.`MESSAGE` (SENT_TIMESTAMP);
CREATE INDEX IF NOT EXISTS INDEX_EDIT
   ON chat.`MESSAGE` (EDIT_TIMESTAMP);
CREATE INDEX IF NOT EXISTS INDEX_FROM
   ON chat.`MESSAGE` (SENDER);
CREATE INDEX IF NOT EXISTS INDEX_TO
   ON chat.`MESSAGE` (DESTINATION);
CREATE INDEX IF NOT EXISTS INDEX_TEXT
   ON chat.`MESSAGE` (`TEXT`(191));

CREATE TABLE IF NOT EXISTS chat.`MESSAGE_READ` (
   `SENDER`                VARCHAR(256) NOT NULL,
   `DESTINATION`           VARCHAR(256) NOT NULL,
   `TIMESTAMP`             BIGINT       NOT NULL,
   `MESSAGE_ID`            VARCHAR(48)
) ENGINE = InnoDB;

CREATE INDEX IF NOT EXISTS INDEX_MESSAGE_READ
   ON chat.`MESSAGE_READ` (`SENDER`(191), `DESTINATION`(191));
CREATE INDEX IF NOT EXISTS INDEX_READ_TIMESTAMP
   ON chat.`MESSAGE_READ` (TIMESTAMP);

CREATE TABLE IF NOT EXISTS chat.`SPACE` (
   `ADDRESS`  VARCHAR(256) NOT NULL,
   `TOPIC`    VARCHAR(256),
   `RESOURCE` VARCHAR(4096)
) ENGINE = InnoDB;

CREATE INDEX IF NOT EXISTS INDEX_SPACE
   ON chat.`SPACE` (`ADDRESS`(191));

CREATE TABLE IF NOT EXISTS chat.`CHANNEL` (
   `ADDRESS`        VARCHAR(256) NOT NULL,
   `CHANNEL_NAME`   VARCHAR(128) NOT NULL,
   `TOPIC`          VARCHAR(256),
   `IS_INVITE_ONLY` BOOLEAN
) ENGINE = InnoDB;

CREATE INDEX IF NOT EXISTS INDEX_CHANNEL
   ON chat.`CHANNEL` (`ADDRESS`(191));

CREATE TABLE IF NOT EXISTS chat.`GROUP` (
   `ADDRESS` VARCHAR(256) NOT NULL,
   `TOPIC`   VARCHAR(256)
) ENGINE = InnoDB;
CREATE INDEX IF NOT EXISTS INDEX_GROUP
   ON chat.`GROUP` (`ADDRESS`(191));

CREATE TABLE IF NOT EXISTS chat.`SUBSCRIPTION` (
   `ADDRESS`            VARCHAR(256) NOT NULL,
   `GROUP_ADDRESS`      VARCHAR(256) NOT NULL,
   `JOINED_TIMESTAMP`   BIGINT,
   `LEFT_TIMESTAMP`     BIGINT,
   `BANNED`             BOOLEAN,
   `CAN_ACCESS_ARCHIVE` BOOLEAN
) ENGINE = InnoDB;

CREATE INDEX IF NOT EXISTS INDEX_SUBSCRIPTION
   ON chat.`SUBSCRIPTION` (`ADDRESS`(191), `GROUP_ADDRESS`(191));

CREATE TABLE IF NOT EXISTS chat.`OWNER` (
   `ADDRESS`            VARCHAR(256) NOT NULL,
   `GROUP_ADDRESS`      VARCHAR(256) NOT NULL
) ENGINE = InnoDB;

CREATE INDEX IF NOT EXISTS INDEX_OWNER
   ON chat.`OWNER` (`ADDRESS`(191), `GROUP_ADDRESS`(191));

_SQL_

Migrate::runSql($sqlStmt);

Migrate::updateSchemaVersion(108, 109);

exit(0);