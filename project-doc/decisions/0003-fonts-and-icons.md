# ADR 0003 — Fonts and icons

**Status:** Accepted · 2026-09-05 · resolves plan decision D8

## Decision
- Typography: Plus Jakarta Sans through `google_fonts`. In Phase 0 the font is fetched at runtime; before the first external build the TTFs are added under `assets/fonts/` so the app renders correctly offline on first launch, and runtime fetching is disabled (`GoogleFonts.config.allowRuntimeFetching = false`).
- Icons: `material_symbols_icons` (Material Symbols Rounded), weight 300, unfilled; the active bottom-navigation icon uses the filled variant.

## Why
The prototype uses exactly these families. `google_fonts` supports both bundling and runtime loading with the same API, so the switch is a build-time change only.

## Consequences
- Follow-up task (Phase 1): download the five weights (400–800), place them under `assets/fonts/`, declare them in `pubspec.yaml`, and disable runtime fetching. Golden tests must use the bundled fonts to be deterministic.
