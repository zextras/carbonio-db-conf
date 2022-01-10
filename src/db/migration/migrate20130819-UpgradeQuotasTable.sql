-- SPDX-FileCopyrightText: 2021 Synacor, Inc.
--
-- SPDX-License-Identifier: GPL-2.0-only
BEGIN TRANSACTION;
DROP TABLE tmp_quotas;
ALTER TABLE quotas RENAME TO tmp_quotas;
CREATE TABLE quotas (
        ID                      INTEGER PRIMARY KEY AUTOINCREMENT,

        PolicyID                INT8,

        Name                    VARCHAR(255) NOT NULL,

        /* Tracking Options */
        Track                   VARCHAR(255) NOT NULL,  /* Format:   <type>:<spec>

                                              SenderIP - This takes a bitmask to mask the IP with. A good default is /24

                                              Sender & Recipient - Either "user@domain" (default), "user@" or "@domain" for the entire
                                                        email addy or email addy domain respectively.
                                           */

        /* Period over which this policy is valid,  this is in seconds */
        Period                  UNSIGNED BIG INT,

        Verdict                 VARCHAR(255),
        Data                    TEXT,

        LastQuota               SMALLINT NOT NULL DEFAULT '0',

        Comment                 VARCHAR(1024),

        Disabled                SMALLINT NOT NULL DEFAULT '0',

        FOREIGN KEY (PolicyID) REFERENCES policies(ID)
);
INSERT INTO "quotas" VALUES(1,5,'Recipient quotas','Recipient:user@domain',3600,'REJECT',NULL,0,NULL,0);
INSERT INTO "quotas" VALUES(2,5,'Quota on all /24s','SenderIP:/24',3600,'REJECT',NULL,0,NULL,0);
INSERT INTO quotas (ID, PolicyID, Name, Track, Period, Verdict, Data, Comment, Disabled)
SELECT ID, PolicyID, Name, Track, Period, Verdict, Data, Comment, Disabled
FROM tmp_quotas;
DROP TABLE tmp_quotas;
COMMIT;
