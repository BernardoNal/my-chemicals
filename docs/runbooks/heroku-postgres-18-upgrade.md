# Heroku Postgres 18 upgrade runbook

**Status:** preparation only; no production database operation has been run. Inventory checked on November 15, 2026.

## Objective and known status

The Heroku notification quoted in issue #205 reports an automatic-upgrade deadline of January 28, 2027 and PostgreSQL 15 end of life on February 28, 2027. The live app check confirmed that `DATABASE_URL` is PostgreSQL 15.18 on the `essential-0` plan, with 10.1 MB of 1 GB used and status `Available`. Heroku reports continuous protection on, but no logical backups or restores. Fork/follow and rollback are unsupported for this database. No database maintenance status was shown by the inventory command.

The application targets PostgreSQL through Rails and the `pg` gem. The schema enables `plpgsql` and `unaccent`; chemical search uses PgSearch full-text search with prefix matching. The application dependency is `pg` 1.7.0. CI is configured for PostgreSQL 18 in checkpoint 1. The local test run passed 268 examples on PostgreSQL 16.15; PostgreSQL 18 CI results are still pending.

## Inventory (read-only)

Authenticate the Heroku CLI locally, then inspect the app without sharing credentials or database URLs:

```sh
heroku pg:info --app my-chemicals
heroku pg:backups --app my-chemicals
heroku addons --app my-chemicals
```

For an Advanced database, use the `heroku data:pg:*` command family instead of `heroku pg:*`. Record the database plan, PostgreSQL version, data size, extensions, followers, backup/protection status, and any application integrations that connect directly to the database. Do not include connection strings or secrets in this runbook.

### Current inventory

Checked with `heroku pg:info --app my-chemicals`, `heroku pg:backups --app my-chemicals`, and `heroku addons --app my-chemicals` on November 15, 2026:

- Add-on: `postgresql-sinuous-70402`, attached as `DATABASE_URL`.
- Plan/version: `essential-0`, PostgreSQL 15.18; status `Available`.
- Data size: 10.1 MB of 1 GB; 13 of 4,000 tables.
- Continuous Protection: reported on. No logical backups or restores were listed.
- Fork/Follow and Rollback: unsupported.
- No other database add-ons were listed for this app.

The app's command line reports Heroku CLI 11.11.0, which meets the upgrade guide's minimum CLI version for direct upgrades.

## Select and rehearse the upgrade

Heroku's supported upgrade path depends on the database plan and size. Review the current [Heroku Postgres version support](https://devcenter.heroku.com/articles/heroku-postgres-version-support) and [upgrade guide](https://devcenter.heroku.com/articles/upgrading-heroku-postgres-databases) after gathering the inventory. Heroku documents direct upgrade, follower failover, and data copy paths; eligibility and downtime differ by plan. Do not choose a path from this runbook alone.

For the current `essential-0` database, Heroku recommends the direct upgrade method and supports it for Essential plans. Heroku says Essential upgrades start immediately and commonly make the database unavailable for about 10 minutes, depending on data size. Follower failover is not available for Essential plans. Data copy is documented for Essential plans under 10 GB, but direct upgrade is the recommended method. Do not execute an upgrade until a backup and recovery path have been verified and a maintenance window approved.

For plans that support the staged upgrade workflow, use Heroku's documented dry run and preparation steps first. Confirm that extensions and application queries work on PostgreSQL 18 using an isolated copy or staging database. Estimate downtime from the live database and Heroku's plan-specific guidance, and agree on a maintenance window before production execution.

## Backup and recovery readiness

Before any production upgrade:

1. Confirm the plan's backup and recovery features and retention.
2. Ensure a recent backup completed successfully; capture a new backup if the plan and database size support it.
3. Validate restore/recovery steps against an isolated database and confirm the application can use the restored copy.
4. Document the selected recovery path, expected data-loss window (if any), and who will make the go/no-go decision.

No production backup has been captured or restored as part of this work. Continuous Protection is reported as on, but the `pg:backups` listing is empty. Confirm what recovery is available for this Essential plan and how it applies during an upgrade; do not treat Continuous Protection as a tested restore. Heroku's [backup documentation](https://devcenter.heroku.com/articles/heroku-postgres-backups) describes plan-specific protection and size limits; verify current details before relying on a method.

## Application validation

On a PostgreSQL 18 database with representative data, validate:

- schema load/migrations and the `plpgsql` and `unaccent` extensions;
- chemical full-text search, including prefix matches;
- the complete RSpec suite and the application's critical inventory and stock movement flows;
- any external jobs or integrations that connect directly to Postgres.

Record the database version, test commands, results, and any compatibility changes here before scheduling production work. Current evidence is limited to the PostgreSQL 16.15 local run and the pending PostgreSQL 18 CI job.

## Production go/no-go

Production execution is a separate step. It requires the live inventory, a rehearsed plan-specific upgrade and recovery procedure, a maintenance window, and explicit approval. No production upgrade, follower creation, data copy, or restore is authorized by this preparation document.
