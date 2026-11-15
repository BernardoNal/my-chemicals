# Heroku Postgres 18 upgrade runbook

**Status:** preparation only; no production database operation has been run.

## Objective and known status

The Heroku notification quoted in issue #205 reports that the `DATABASE` add-on is running PostgreSQL 15, with an automatic-upgrade deadline of January 28, 2027 and PostgreSQL 15 end of life on February 28, 2027. These details have not yet been checked against the live Heroku app. Confirm the database name, current version, plan, size, followers, and maintenance status in Heroku before selecting an upgrade method.

The application targets PostgreSQL through Rails and the `pg` gem. The schema enables `plpgsql` and `unaccent`; chemical search uses PgSearch full-text search with prefix matching. The application dependency is `pg` 1.7.0. CI is configured for PostgreSQL 18 in checkpoint 1. The local test run passed 268 examples on PostgreSQL 16.15; PostgreSQL 18 CI results are still pending.

## Inventory (read-only)

Authenticate the Heroku CLI locally, then inspect the app without sharing credentials or database URLs:

```sh
heroku pg:info --app my-chemicals
heroku pg:backups --app my-chemicals
heroku addons --app my-chemicals
```

For an Advanced database, use the `heroku data:pg:*` command family instead of `heroku pg:*`. Record the database plan, PostgreSQL version, data size, extensions, followers, backup/protection status, and any application integrations that connect directly to the database. Do not include connection strings or secrets in this runbook.

## Select and rehearse the upgrade

Heroku's supported upgrade path depends on the database plan and size. Review the current [Heroku Postgres version support](https://devcenter.heroku.com/articles/heroku-postgres-version-support) and [upgrade guide](https://devcenter.heroku.com/articles/upgrading-heroku-postgres-databases) after gathering the inventory. Heroku documents direct upgrade, follower failover, and data copy paths; eligibility and downtime differ by plan. Do not choose a path from this runbook alone.

For plans that support the staged upgrade workflow, use Heroku's documented dry run and preparation steps first. Confirm that extensions and application queries work on PostgreSQL 18 using an isolated copy or staging database. Estimate downtime from the live database and Heroku's plan-specific guidance, and agree on a maintenance window before production execution.

## Backup and recovery readiness

Before any production upgrade:

1. Confirm the plan's backup and recovery features and retention.
2. Ensure a recent backup completed successfully; capture a new backup if the plan and database size support it.
3. Validate restore/recovery steps against an isolated database and confirm the application can use the restored copy.
4. Document the selected recovery path, expected data-loss window (if any), and who will make the go/no-go decision.

No production backup has been captured or restored as part of this work. Heroku's [backup documentation](https://devcenter.heroku.com/articles/heroku-postgres-backups) describes plan-specific protection and size limits; verify current details before relying on a method.

## Application validation

On a PostgreSQL 18 database with representative data, validate:

- schema load/migrations and the `plpgsql` and `unaccent` extensions;
- chemical full-text search, including prefix matches;
- the complete RSpec suite and the application's critical inventory and stock movement flows;
- any external jobs or integrations that connect directly to Postgres.

Record the database version, test commands, results, and any compatibility changes here before scheduling production work. Current evidence is limited to the PostgreSQL 16.15 local run and the pending PostgreSQL 18 CI job.

## Production go/no-go

Production execution is a separate step. It requires the live inventory, a rehearsed plan-specific upgrade and recovery procedure, a maintenance window, and explicit approval. No production upgrade, follower creation, data copy, or restore is authorized by this preparation document.
