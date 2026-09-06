# ADR 0007 — Transactions store a category's label, not its id

**Status:** Accepted · 2026-09-06

## Decision
Making categories user-editable (Phase 2's Category manager) adds a
`TransactionCategories` table with a UUID id, a name, a kind (expense/income), a sort
order and an icon key. `Transactions.category` stays what it already was — the category's
**name**, as free text — rather than becoming a foreign key to that table.

Renaming a category therefore cascades: `TransactionCategoryRepository.rename` rewrites
the label on every transaction that carried the old name, inside the same database
transaction as the rename itself. Deleting a category is a soft delete that hides it from
the pickers and leaves every transaction's stored label untouched.

## Why
- Every existing Finance query already groups by that text — `categoryTotals`'s
  `GROUP BY category` is the "By category" bars. A foreign key would mean a join on the
  dashboard's hottest query, plus a data migration for the rows Phase 2's first slice
  already wrote.
- A deleted category should not un-name the money that was spent under it. With a label,
  "Groceries" keeps reading as Groceries in June even after the user renames or removes
  the category in September; with an id, the row would resolve to a dangling reference
  and the app would have to invent a fallback name.
- The cascade is bounded and cheap: one `UPDATE ... WHERE category = ?`, on a table
  indexed by date, on a local single-user database.

## Consequences
- Rename is the only operation that has to touch two tables, and it must stay atomic —
  a half-applied rename would leave money grouped under a name no category owns.
- Two categories can be given the same name. Nothing breaks (they group together, which
  is what identical names mean to a reader), so the manager does not forbid it.
- A transaction can carry a label no live category has: one the user deleted, or one
  written by an earlier version. The pickers surface it anyway when the transaction is
  being edited, rather than silently clearing it on the next save.
- Phase 5 sync ships category rows and transaction rows independently; there is no
  referential integrity between them to reconcile, and a rename that loses a race
  produces a wrong label, never an orphan.
- Colour is deliberately not stored on a category. Nothing colours a category today —
  the "By category" bars are all accent — so a colour column would be data no surface
  reads. It is a column to add when a surface wants one.
