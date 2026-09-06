# ADR 0006 — How "Income" on Finance is captured

**Status:** Accepted · 2026-09-06 · resolves plan decision D4

## Decision
Income is a `Transaction` with `type = income`, entered through the same Add expense
keypad as an expense (a type toggle switches the sign). Finance's "This month" income
figure sums the month's income transactions when at least one exists; when none do, it
falls back to a `Settings`-backed "monthly budget" figure the user can set once in
Finance settings. The fallback exists so the dashboard has a sensible income number
from day one, before the user has logged a single paycheque.

## Why
A pure transaction model is the simplest schema — one table, one repository, no second
"budget" entity to keep in sync — and it is what recurring/one-off income actually is.
But requiring a transaction before Finance shows any income number would make the
dashboard read ₹0 for every new user, which is worse than the prototype's hard-coded
figure it replaces (G11). The monthly-budget setting is the minimal fallback that
avoids that without a second first-class entity.

## Consequences
- `Transaction` needs a `type` (`income` | `expense`) alongside the existing category
  and amount fields; the keypad's amount sign follows the type, not a separate field.
- The monthly-budget figure lives in `Settings` (same JSON key/value table as
  `notifications.task_reminders_enabled` and appearance), not a new table.
- Finance's income tile reads: sum this month's income transactions; if that sum is
  zero and no income transaction exists this month, show the monthly-budget setting
  instead (rendered distinctly, e.g. "Budgeted" vs. an actual figure, so the two are
  never confused).
