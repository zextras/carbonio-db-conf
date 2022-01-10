-- SPDX-FileCopyrightText: 2021 Synacor, Inc.
--
-- SPDX-License-Identifier: GPL-2.0-only
.bail ON
.read "@ZIMBRA_INSTALL@db/db.sql"
.read "@ZIMBRA_INSTALL@db/versions-init.sql"
.read "@ZIMBRA_INSTALL@db/default-volumes.sql"
.exit
