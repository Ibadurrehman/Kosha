# ADR 0001 — Application and bundle identifier

**Status:** Accepted · 2026-09-05 · resolves plan decision D1

## Decision
Use `com.taritas.kosha` as the Android `applicationId`/`namespace`, the Kotlin package of `MainActivity`, and the iOS `PRODUCT_BUNDLE_IDENTIFIER`. The `kosha://` URL scheme is registered on both platforms for deep links.

## Why
The identifier cannot change after the first store upload. The team's domain is taritas.com, so the reverse-domain form is the conventional choice. It was applied in Phase 0 before any build was distributed.

## Consequences
- Any Firebase/Supabase/OAuth configuration must use this id.
- Changing it later means a new store listing.
