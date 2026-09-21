# ADR 0008 — Archiving a space keeps its links

**Status:** Accepted · 2026-09-22

## Decision
A space is never deleted. The only removal it has is archiving, which sets `archivedAt`
and nothing else: the `space_id` on every task, bill, event and transaction that pointed
at it is **left in place**.

Section 6.5's acceptance criterion reads "deleting a user space archives it and unlinks
items (items survive)". The archive half is literal. The unlink half is done at *read*
time rather than by writing nulls: every picker, aggregator and "Belongs to" chip reads
through `SpaceRepository.watchActive`, so an item in an archived space shows no space and
appears in no space's sections — while the column still remembers where it came from.

The `Spaces` table therefore has no `deletedAt`, unlike every other table in the database.

## Why
- **Undo has to work.** Every destructive action in this app is a toast with an Undo
  (tasks, bills, transactions, categories). Nulling `space_id` across four tables is not
  reversible without recording every id that was cleared somewhere, which is a
  second, worse copy of the link. Keeping the column makes restore a one-row update that
  brings the whole space back intact, which `space_repository_test.dart` asserts.
- **The observable behaviour is identical.** "Unlinked" is only ever visible through a
  surface, and no surface reads an archived space. A user cannot tell the difference
  between a nulled column and one that is filtered out — except when they undo.
- **Seeding needs a non-destructive hidden state anyway.** A system space whose
  onboarding area was not picked starts archived (`area.dart` asked Phase 3 to read the
  selection as a starting visibility). That space has no items yet, but it establishes
  that "archived" must mean *folded away*, not *emptied* — one meaning for the flag is
  better than two.
- A second timestamp meaning "gone for real" would be a column no surface writes — the
  same reasoning `transaction_category_table.dart` gives for not storing a colour.

## Consequences
- Any query that resolves a `space_id` to a name must go through the repository's active
  list, or it will show an archived space's name. Joining straight to the `spaces` table
  is the mistake this record exists to flag.
- A `space_id` can outlive the user's interest in it indefinitely. That is the cost of
  reversibility, and it is bounded: the row is one text column that is already there.
- Phase 5 syncs `archivedAt` as a state field. There is no tombstone for a space because
  a space never dies; if a later phase ever needs true deletion, it is a new column and a
  new record, not a change to this one.
