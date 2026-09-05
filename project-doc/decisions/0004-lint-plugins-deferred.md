# ADR 0004 — riverpod_lint / custom_lint deferred

**Status:** Accepted · 2026-09-05

## Decision
`riverpod_lint` and `custom_lint` are not added in Phase 0. The project uses `flutter_lints` with a stricter rule set in `analysis_options.yaml`.

## Why
On Flutter 3.44.6 / Dart 3.12.2 the current `drift_dev` (2.34) and `freezed` (4.0.0-dev) generators require a newer `analyzer` major than `custom_lint` 0.8.x supports; `pub` cannot solve the set, and pinning `freezed` back to 3.x conflicts with `drift_dev`.

## Consequences
- Re-try adding both packages at the start of Phase 1 and after each Flutter upgrade; enable the `custom_lint` analyzer plugin in `analysis_options.yaml` when it resolves.
- Until then, provider misuse (missing `ref.watch`, unused providers) is caught in code review.
- `freezed` is on a 4.0.0-dev build because the 4.0.x stable line requires Dart 3.13; upgrade when the SDK moves.
