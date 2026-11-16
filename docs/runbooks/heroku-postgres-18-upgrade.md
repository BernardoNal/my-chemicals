# Heroku Postgres 18 upgrade runbook

**Status:** production upgrade completed on November 15, 2026. Inventory and outcome recorded below.

## Objective and known status

The Heroku notification quoted in issue #205 reported an automatic-upgrade deadline of January 28, 2027 and PostgreSQL 15 end of life on February 28, 2027. The live inventory on November 15, 2026 confirmed that `DATABASE_URL` was PostgreSQL 15.18 on the `essential-0` plan, with 10.1 MB of 1 GB used. The database has since been upgraded to PostgreSQL 18.4; see the production outcome below. Heroku reported continuous protection on, but no logical backups or restores before the upgrade. Fork/follow and rollback are unsupported for this plan.

The application targets PostgreSQL through Rails and the `pg` gem. The schema enables `plpgsql` and `unaccent`; chemical search uses PgSearch full-text search with prefix matching. The application dependency is `pg` 1.7.0. CI is configured for PostgreSQL 18 in checkpoint 1. The local test run passed 268 examples on PostgreSQL 16.15. The public app endpoint returned HTTP 200 after the production upgrade; the RSpec suite has not been rerun against PostgreSQL 18 in this environment.

## Pre-upgrade inventory

Checked with `heroku pg:info --app my-chemicals`, `heroku pg:backups --app my-chemicals`, and `heroku addons --app my-chemicals` on November 15, 2026:

- Add-on: `postgresql-sinuous-70402`, attached as `DATABASE_URL`.
- Plan/version: `essential-0`, PostgreSQL 15.18; status `Available`.
- Data size: 10.1 MB of 1 GB; 13 of 4,000 tables.
- Continuous Protection: reported on. No logical backups or restores were listed.
- Fork/Follow and Rollback: unsupported.
- No other database add-ons were listed for this app.

The app's command line reports Heroku CLI 11.11.0, which meets the upgrade guide's minimum CLI version for direct upgrades.

## Upgrade method

Heroku recommends the direct upgrade method for this `essential-0` database. Essential upgrades start immediately, with database access restricted during the operation; Heroku estimates about 10 minutes of downtime for most use cases. Follower failover is unavailable on Essential plans. The database was upgraded with the direct method described in Heroku's [upgrade guide](https://devcenter.heroku.com/articles/upgrading-heroku-postgres-databases). The staged preparation and dry-run steps in that guide apply to Standard-tier and higher plans, not this Essential plan.

## Backup and recovery

Before the upgrade, Heroku's plan information reported Continuous Protection on, while `pg:backups` had no logical backups listed. A logical backup (`b003`) was captured successfully and downloaded before the upgrade. The archive index was readable with `pg_restore --list`; no restore rehearsal was performed. The downloaded copy is stored outside the repository on the operator's machine. Heroku's [backup documentation](https://devcenter.heroku.com/articles/heroku-postgres-backups) describes plan-specific protection and size limits.

## Application validation

After the upgrade, the database was available on PostgreSQL 18.4 and a request to the public root returned HTTP 200 after following its redirect. The full RSpec suite and authenticated inventory/stock movement workflows were not run against PostgreSQL 18. CI is configured for PostgreSQL 18; record its result here when available. The local RSpec suite had passed 268 examples on PostgreSQL 16.15 before the production upgrade.

## Production outcome

On November 15, 2026, after explicit approval and with the app's maintenance mode enabled, the direct upgrade was started for `DATABASE_URL` with target PostgreSQL 18. Heroku reported `version upgrade: succeeded`. The database returned to `Available` on PostgreSQL 18.4 with 9.92 MB used and 13 tables. Maintenance mode was turned off after confirmation.

No follower was created, and no data copy or restore was performed.
