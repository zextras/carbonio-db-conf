#!/usr/bin/perl
#
# SPDX-FileCopyrightText: 2021 Synacor, Inc.
#
# SPDX-License-Identifier: GPL-2.0-only
#

use strict;
use Migrate;

########################################################################################################################

Migrate::verifySchemaVersion(91);

addVolumeBlobsTable();
addVolumeMetadataColumn();

Migrate::updateSchemaVersion(91, 92);

exit(0);

########################################################################################################################

sub addVolumeBlobsTable() {
    Migrate::logSql("Adding VOLUME_BLOBS table...");
    my $sql = <<_EOF_;
CREATE TABLE IF NOT EXISTS volume_blobs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  volume_id TINYINT NOT NULL,
  mailbox_id INTEGER NOT NULL,
  item_id INTEGER NOT NULL,
  revision INTEGER NOT NULL,
  blob_digest VARCHAR(44),
  processed BOOLEAN default false,
  
  INDEX i_blob_digest (blob_digest),

  CONSTRAINT uc_blobinfo UNIQUE (volume_id,mailbox_id,item_id,revision)
) ENGINE = InnoDB;
_EOF_
  Migrate::runSql($sql);
}

sub addVolumeMetadataColumn() {
    Migrate::logSql("Adding METADATA column to VOLUME...");
    my $sql = <<_EOF_;
ALTER TABLE volume ADD COLUMN metadata MEDIUMTEXT AFTER compression_threshold;
_EOF_
  Migrate::runSql($sql);
}

