# carbonio-db-conf

![Contributors](https://img.shields.io/github/contributors/zextras/carbonio-db-conf "Contributors")
![Activity](https://img.shields.io/github/commit-activity/m/zextras/carbonio-db-conf "Activity") ![License](https://img.shields.io/badge/license-AGPL%203-green
"License")
![Project](https://img.shields.io/badge/project-carbonio-informational
"Project")
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/zextras.svg?style=social&label=Follow%20%40zextras)](https://twitter.com/zextras)

Configuration structure for databases and migration scripts

## Architecture

### SQL scripts
- create_database.sql (e.g.: [src/db/mysql/create_database.sql](src/db/mysql/create_database.sql)) \
is a SQL template used by mailbox to create/provision a new mailbox (database name is dynamic).

### Migration Scripts
Migration logs are stored under /opt/zextras/log/sqlMigration.log.

Scripts inside (e.g.: [src/db/migration](src/db/migration)) perform migration on existing databases \
and are placed under /opt/zextras/db/mailbox/migrations

You can **manually** execute one by running (**TEST PURPOSES**):
> cd /opt/zextras/db/mailbox/migrations && perl -I. <migration_name>.pl


## License

See [COPYING](COPYING) file for details
