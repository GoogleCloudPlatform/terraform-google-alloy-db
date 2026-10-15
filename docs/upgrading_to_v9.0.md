# Upgrading to v9.0

The v9.0 release contains backwards-incompatible changes, new validations, and bug fixes.

## `read_pool_instance.display_name` is now wired and optional

Previously, `display_name` was a required attribute (`string`) in `var.read_pool_instance`, but it was not passed to the `google_alloydb_instance.read_pool` resource in `main.tf` (leaving `display_name` unset/`null` on existing read pool instances).

In v9.0:
- `display_name` in `var.read_pool_instance` is now `optional(string)` (matching `var.primary_instance`).
- `display_name = each.value.display_name` is now passed to `google_alloydb_instance.read_pool`.

### Upgrade Guidance for Existing Read Pool Instances
- **If you do NOT want to update `display_name` on existing read pool instances:** Because `display_name` is now optional, you can safely **remove `display_name`** (or set `display_name = null`) in your `read_pool_instance` configuration. Doing so will result in **no changes (`No-op`)** during `terraform plan` / `terraform apply`.
- **If you keep `display_name` set in `var.read_pool_instance`:** The next `terraform apply` will show an **in-place, non-destructive update (`~ update in-place`)** to set `display_name` on the existing read pool instance(s). This is a control-plane metadata update only and does **not** recreate or restart the database instance.

## `cluster_initial_user` and `cluster` output marked as `sensitive`

- `var.cluster_initial_user` now has `sensitive = true` to redact the database user password in Terraform plan and apply output.
- `output.cluster` now has `sensitive = true` because it exports the full `google_alloydb_cluster.default` resource object, which includes `initial_user` credentials. If a root module or downstream consumer references `module.<name>.cluster` in an output, that output must either be marked `sensitive = true` or reference specific non-sensitive outputs (such as `cluster_id` or `cluster_name`).

## Expanded `machine_cpu_count` validation for C4A, C4, and Z3 machine series

- Updated `primary_instance.machine_cpu_count` and `read_pool_instance[*].machine_cpu_count` validations to support all 19 AlloyDB vCPU counts across **N2**, **C4A Axion-based**, **C4**, and **Z3** (`standardlssd` and `highlssd`) machine series:
  `[1, 2, 4, 8, 14, 16, 22, 24, 32, 44, 48, 64, 72, 88, 96, 128, 144, 192, 288]`
- `machine_cpu_count` may also be set to `null` when `machine_type` is explicitly specified.

## Bug Fixes

- **`automated_backup_policy.weekly_schedule` is now dynamic:** `weekly_schedule` in `google_alloydb_cluster.default` is now a `dynamic` block so `automated_backup_policy` can be configured without requiring `weekly_schedule` (for example, when setting `enabled = false`).
- **`primary_instance.query_insights_config` optional attributes:** Fixed validation logic using `coalesce` so omitting optional fields (`query_string_length` or `query_plans_per_minute`) inside `query_insights_config` uses their default values (`1024` and `5`) instead of failing validation.

## New Variable Validations

Existing configurations with invalid parameter values that previously bypassed Terraform variable validation may now fail fast during `terraform plan` / `terraform validate`:

- **`cluster_id` & `read_pool_instance[*].instance_id`:** Must satisfy RFC 1035 naming (`^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$`).
- **`cluster_type`:** Must be one of `["PRIMARY", "SECONDARY"]`.
- **`subscription_type`:** Must be one of `["STANDARD", "TRIAL"]`.
- **`database_version`:** Must be one of `["POSTGRES_14", "POSTGRES_15", "POSTGRES_16", "POSTGRES_17"]` when specified.
- **`continuous_backup_recovery_window_days`:** Must be between `1` and `35`.
- **`maintenance_update_policy`:** `day` must be a valid day of the week (`MONDAY` through `SUNDAY`) and `start_time.hours` must be between `0` and `23`.
- **`automated_backup_policy`:**
  - `weekly_schedule.start_times` entries must match `HH:MM:SS:NANOS` (e.g., `"02:00:00:0"`).
  - Only one of `quantity_based_retention_count` or `time_based_retention_count` may be set at the same time.
- **`primary_instance.availability_type`:** Must be one of `["REGIONAL", "ZONAL"]` when specified.
- **`read_pool_instance[*].node_count`:** Must be between `1` and `20`.
- **`read_pool_instance[*].query_insights_config`:** `query_string_length` must be between `256` and `4500`, and `query_plans_per_minute` must be between `0` and `20`.
- **`restore_cluster`:** Exactly one of `restore_backup_source` or `restore_continuous_backup_source` must be set when `restore_cluster` is specified.
